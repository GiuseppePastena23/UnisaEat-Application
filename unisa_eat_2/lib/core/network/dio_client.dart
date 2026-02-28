import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';

import 'interceptors.dart';

class DioClient {

  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseURL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        responseType: ResponseType.json,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10)
      ),
    );
    _dio.interceptors.addAll([
      LoggerInterceptor(),
      TokenInterceptor(),
      RetryInterceptor(
        dio: _dio,
        logPrint: (message) => print('Retry: $message'),
        retries: 3,
        retryDelays: [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
      ),
    ]);
  }

  // GET METHOD
  Future < Response > get(
    String url, {
      Map < String,
      dynamic > ? queryParameters,
      Options ? options,
      CancelToken ? cancelToken,
      ProgressCallback ? onReceiveProgress,
    }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    }
    on DioException {
      rethrow;
    }
  }

  // POST METHOD
  Future < Response > post(
    String url, {
      data,
      Map < String,
      dynamic > ? queryParameters,
      Options ? options,
      ProgressCallback ? onSendProgress,
      ProgressCallback ? onReceiveProgress,
    }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT METHOD
  Future < Response > put(
    String url, {
      dynamic data,
      Map < String,
      dynamic > ? queryParameters,
      Options ? options,
      CancelToken ? cancelToken,
      ProgressCallback ? onSendProgress,
      ProgressCallback ? onReceiveProgress,
    }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE METHOD
  Future < dynamic > delete(
    String url, {
      data,
      Map < String,
      dynamic > ? queryParameters,
      Options ? options,
      CancelToken ? cancelToken,
    }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}