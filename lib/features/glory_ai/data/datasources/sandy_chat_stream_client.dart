import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/result/result.dart';
import '../models/sandy_models.dart';

final class SandyChatStreamClient {
  const SandyChatStreamClient(this._dio);

  final Dio _dio;

  Future<Result<SandyChatResponseModel>> streamMessage({
    required String message,
    String? conversationId,
    required void Function(String text) onDelta,
  }) async {
    try {
      final response = await _dio.post<ResponseBody>(
        Endpoints.mobileSandyChatStream,
        data: SandyChatRequest(
          message: message,
          conversationId: conversationId,
        ).toJson(),
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 5),
          headers: const {
            'Accept': 'text/event-stream',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;
      if (body == null) {
        return Failure(ServerFailure(FallbackMessages.errorTryAgain));
      }

      return _readSse(
        body.stream,
        onDelta: onDelta,
      );
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is AppException) {
        return Failure(_mapException(inner));
      }
      return Failure(
        switch (e.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.connectionError =>
            NetworkFailure(FallbackMessages.noInternet),
          _ => ServerFailure(e.message ?? FallbackMessages.errorGeneral),
        },
      );
    } on AppException catch (e) {
      return Failure(_mapException(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<SandyChatResponseModel>> _readSse(
    Stream<Uint8List> byteStream, {
    required void Function(String text) onDelta,
  }) async {
    var buffer = '';
    var assembled = StringBuffer();
    SandyChatResponseModel? done;

    await for (final chunk in utf8.decoder.bind(byteStream)) {
      buffer += chunk.replaceAll('\r\n', '\n');
      var separator = buffer.indexOf('\n\n');
      while (separator != -1) {
        final frame = buffer.substring(0, separator);
        buffer = buffer.substring(separator + 2);

        final parsed = _parseFrame(frame);
        if (parsed != null) {
          switch (parsed.event) {
            case 'delta':
              final text = parsed.data['text'] as String? ?? '';
              if (text.isNotEmpty) {
                assembled.write(text);
                onDelta(text);
              }
            case 'done':
              done = _doneModel(parsed.data, assembled.toString());
            case 'error':
              final message = parsed.data['message'] as String? ??
                  FallbackMessages.errorTryAgain;
              return Failure(ServerFailure(message));
            case 'end':
              break;
          }
        }

        separator = buffer.indexOf('\n\n');
      }
    }

    if (done == null) {
      return Failure(ServerFailure(FallbackMessages.errorTryAgain));
    }
    return Success(done);
  }

  _SseFrame? _parseFrame(String frame) {
    if (frame.trim().isEmpty) return null;

    var event = 'message';
    final dataLines = <String>[];
    for (final line in frame.split('\n')) {
      if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).trim());
      }
    }
    if (dataLines.isEmpty) return null;

    final raw = dataLines.join('\n');
    if (raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    return _SseFrame(
      event: event,
      data: Map<String, dynamic>.from(decoded),
    );
  }

  SandyChatResponseModel _doneModel(Map<String, dynamic> payload, String answer) {
    final citations = (payload['citations'] as List?)
            ?.whereType<Map>()
            .map(
              (item) => SandyCitationModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList() ??
        const <SandyCitationModel>[];

    final metaRaw = payload['meta'];
    return SandyChatResponseModel(
      conversationId: payload['conversationId'] as String? ?? '',
      messageId: payload['messageId'] as String? ?? '',
      answer: answer,
      citations: citations,
      refusalReason: payload['refusalReason'] as String?,
      meta: metaRaw is Map<String, dynamic>
          ? SandyChatMetaModel.fromJson(metaRaw)
          : metaRaw is Map
              ? SandyChatMetaModel.fromJson(Map<String, dynamic>.from(metaRaw))
              : null,
    );
  }

  AppFailure _mapException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        UnauthorizedException() => UnauthorizedFailure(e.message),
        ServerException() => ServerFailure(e.message),
        CacheException() => CacheFailure(e.message),
        ValidationException() => ValidationFailure(e.message),
      };
}

final class _SseFrame {
  const _SseFrame({required this.event, required this.data});

  final String event;
  final Map<String, dynamic> data;
}
