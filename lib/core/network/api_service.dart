import 'package:dio/dio.dart';

import '../error/app_exception.dart';
import '../error/app_failure.dart';
import '../result/result.dart';

abstract base class ApiService {
  const ApiService(this.dio);

  final Dio dio;

  Future<Result<T>> get<T>(
    String path, {
    required T Function(dynamic data) fromJson,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_mapError(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<T>> post<T>(
    String path, {
    required T Function(dynamic data) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_mapError(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<T>> put<T>(
    String path, {
    required T Function(dynamic data) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_mapError(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<T>> delete<T>(
    String path, {
    required T Function(dynamic data) fromJson,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_mapError(e));
    } catch (e) {
      return Failure(ServerFailure(e.toString()));
    }
  }

  AppFailure _mapError(DioException e) {
    final inner = e.error;
    if (inner is AppException) {
      return switch (inner) {
        NetworkException() => NetworkFailure(inner.message),
        UnauthorizedException() => UnauthorizedFailure(inner.message),
        ServerException() => ServerFailure(inner.message),
        CacheException() => CacheFailure(inner.message),
        ValidationException() => ValidationFailure(inner.message),
      };
    }
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError =>
        const NetworkFailure(),
      _ => ServerFailure(e.message ?? 'Unexpected error'),
    };
  }
}
