import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/sandy_api_responses.dart';
import '../models/sandy_models.dart';
import 'sandy_api.dart';

final class SandyRemoteApiService extends ApiService {
  SandyRemoteApiService(super.dio, this._sandyApi);

  final SandyApi _sandyApi;

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
