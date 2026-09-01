import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/result/result.dart';
import '../models/chat_api_responses.dart';
import 'coach_chat_api.dart';

final class CoachChatRemoteApiService extends ApiService {
  CoachChatRemoteApiService(super.dio, this._coachChatApi);

  final CoachChatApi _coachChatApi;

  Future<Result<ChatConversationsApiResponse>> getConversations() =>
      _guard(() async {
        final response = await _coachChatApi.getConversations();
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<ChatMessagesApiResponse>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 30,
  }) =>
      _guard(() async {
        final response = await _coachChatApi.getMessages(
          conversationId,
          page: page,
          limit: limit,
        );
        if (!response.success) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response);
      });

  Future<Result<int>> markAsRead(String conversationId) => _guard(() async {
        final response = await _coachChatApi.markAsRead(conversationId);
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!.updated);
      });

  Future<Result<int>> getUnreadCount() => _guard(() async {
        final response = await _coachChatApi.getUnreadCount();
        if (!response.success || response.data == null) {
          return Failure(
            ServerFailure(response.message ?? FallbackMessages.errorTryAgain),
          );
        }
        return Success(response.data!.count);
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
