import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/result/result.dart';
import '../models/sandy_api_responses.dart';
import '../models/sandy_models.dart';
import 'sandy_api.dart';
import 'sandy_chat_stream_client.dart';

final class SandyRemoteApiService extends ApiService {
  SandyRemoteApiService(super.dio, this._sandyApi)
      : _streamClient = SandyChatStreamClient(dio);

  final SandyApi _sandyApi;
  final SandyChatStreamClient _streamClient;

  Future<Result<SandyChatResponseModel>> sendMessage({
    required String message,
    String? conversationId,
  }) =>
      _guard(() async {
        final response = await _sandyApi.sendMessage(
          SandyChatRequest(message: message, conversationId: conversationId),
        );
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<SandyChatResponseModel>> streamMessage({
    required String message,
    String? conversationId,
    required void Function(String text) onDelta,
  }) =>
      _streamClient.streamMessage(
        message: message,
        conversationId: conversationId,
        onDelta: onDelta,
      );

  Future<Result<List<String>>> getSuggestions({required String lang}) =>
      _guard(() async {
        final response = await _sandyApi.getSuggestions(lang: lang);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<List<SandyConversationModel>>> getConversations() =>
      _guard(() async {
        final response = await _sandyApi.getConversations();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<SandyMessagesApiResponse>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 30,
  }) =>
      _guard(() async {
        final response = await _sandyApi.getMessages(
          conversationId,
          page: page,
          limit: limit,
        );
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<void>> renameConversation({
    required String conversationId,
    required String title,
  }) =>
      _guard(() async {
        final response = await _sandyApi.renameConversation(
          conversationId,
          SandyRenameConversationRequest(title: title),
        );
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return const Success(null);
      });

  Future<Result<void>> deleteConversation(String conversationId) =>
      _guard(() async {
        final response = await _sandyApi.deleteConversation(conversationId);
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return const Success(null);
      });

  Future<Result<String>> uploadFile(String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await dio.post<Map<String, dynamic>>(
        Endpoints.mobileUploads,
        data: formData,
      );

      final body = response.data;
      if (body == null || body['success'] != true) {
        return Failure(
          ServerFailure(
            body?['message'] as String? ?? FallbackMessages.errorTryAgain,
          ),
        );
      }

      final data = body['data'];
      final url = switch (data) {
        final String value => value,
        final Map<String, dynamic> map =>
          map['url'] as String? ?? map['path'] as String?,
        _ => null,
      };

      if (url == null || url.isEmpty) {
        return Failure(ServerFailure(FallbackMessages.errorTryAgain));
      }

      return Success(url);
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

  Future<Result<SandyAnalyzeDocumentModel>> analyzeDocument({
    required String fileUrl,
    String? note,
    String? conversationId,
    String? lang,
  }) =>
      _guard(() async {
        final response = await _sandyApi.analyzeDocument(
          SandyAnalyzeDocumentRequest(
            fileUrl: fileUrl,
            note: note,
            conversationId: conversationId,
            lang: lang,
          ),
        );
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<SandyDocumentsApiResponse>> getDocuments({
    int page = 1,
    int limit = 20,
  }) =>
      _guard(() async {
        final response = await _sandyApi.getDocuments(page: page, limit: limit);
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<SandyMedicalDocumentModel>> getDocument(String documentId) =>
      _guard(() async {
        final response = await _sandyApi.getDocument(documentId);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!);
      });

  Future<Result<void>> deleteDocument(String documentId) =>
      _guard(() async {
        final response = await _sandyApi.deleteDocument(documentId);
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return const Success(null);
      });

  Future<Result<T>> _guard<T>(Future<Result<T>> Function() call) async {
    try {
      return await call();
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

  AppFailure _mapException(AppException e) => switch (e) {
        NetworkException() => NetworkFailure(e.message),
        UnauthorizedException() => UnauthorizedFailure(e.message),
        ServerException() => ServerFailure(e.message),
        CacheException() => CacheFailure(e.message),
        ValidationException() => ValidationFailure(e.message),
      };
}
