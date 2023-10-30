import 'package:app_template/core/extensions/either_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class IApiSource {
  abstract final Map<String, dynamic> defaultHeaders;

  void addToDefaultHeaders(Map<String, dynamic> headers);

  Future<Either<Exception, T>> get<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Either<Exception, T>> post<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic payload,
  });

  Future<Either<Exception, T>> put<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? data,
  });

  Future<Either<Exception, T>> patch<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Either<Exception, void>> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

class ApiSource implements IApiSource {
  ApiSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  void addLogInterceptors() {
    if (kReleaseMode == true) return;
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    );
  }

  @override
  final Map<String, dynamic> defaultHeaders = {
    'Content-Type': 'application/json-patch+json',
    'accept': '*/*',
  };

  @override
  void addToDefaultHeaders(Map<String, dynamic> headers) {
    defaultHeaders.addAll(headers);
  }

  @override
  Future<Either<Exception, T>> get<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _errorWrapper(() async {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: {...?headers, ...defaultHeaders}),
      );

      return _castErrorWrapper<T, Map<String, dynamic>>(
        response,
        (map) => fromMapFunc(map).toRight(),
      );
    });
  }

  @override
  Future<Either<Exception, T>> post<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic payload,
  }) {
    return _errorWrapper(() async {
      final response = await _dio.post(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: Options(headers: {...?headers, ...defaultHeaders}),
      );

      return _castErrorWrapper<T, Map<String, dynamic>>(
        response,
        (map) => fromMapFunc(map).toRight(),
      );
    });
  }

  @override
  Future<Either<Exception, void>> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _errorWrapper(() async {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: {...?headers, ...defaultHeaders}),
      );

      return _castErrorWrapper<void, Map<String, dynamic>>(
        response,
        (_) => right(null),
      );
    });
  }

  @override
  Future<Either<Exception, T>> put<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? data,
  }) {
    return _errorWrapper(() async {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: {...?headers, ...defaultHeaders}),
      );

      return _castErrorWrapper<T, Map<String, dynamic>>(
        response,
        (map) => fromMapFunc(map).toRight(),
      );
    });
  }

  @override
  Future<Either<Exception, T>> patch<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromMapFunc,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _errorWrapper(() async {
      final response = await _dio.patch(
        path,
        queryParameters: queryParameters,
        options: Options(headers: {...?headers, ...defaultHeaders}),
      );

      return _castErrorWrapper<T, Map<String, dynamic>>(
        response,
        (map) => fromMapFunc(map).toRight(),
      );
    });
  }

  Either<Exception, T> _castErrorWrapper<T, R>(
    Response<dynamic>? response,
    Either<Exception, T> Function(R data) func,
  ) {
    try {
      final R map;
      try {
        map = response!.data as R;
      } catch (error) {
        return Left(Exception(error.toString()));
      }

      return func(map);
    } catch (error) {
      return Left(Exception(error.toString()));
    }
  }

  Future<Either<Exception, T>> _errorWrapper<T>(
    Future<Either<Exception, T>> Function() function,
  ) async {
    try {
      return await function();
    } on DioException catch (e) {
      return Left(Exception(e.message));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
