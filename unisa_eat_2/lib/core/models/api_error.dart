import 'package:dio/dio.dart';

enum ErrorType {
  network,
  server,
  auth,
  validation,
  balance,
  unknown,
}

class ApiError {
  final ErrorType type;
  final Map<String, dynamic>? details;

  ApiError({required this.type, this.details});

  factory ApiError.fromDioException(dynamic error) {
    ErrorType type = ErrorType.unknown;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          type = ErrorType.network;
          break;
        case DioExceptionType.badResponse:
          final data = error.response?.data;
          if (data is Map<String, dynamic> && data['error'] == 'Insufficient balance') {
            type = ErrorType.balance;
          } else if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
            type = ErrorType.auth;
          } else if (error.response?.statusCode != null && error.response!.statusCode! >= 400 && error.response!.statusCode! < 500) {
            type = ErrorType.validation;
          } else if (error.response?.statusCode != null && error.response!.statusCode! >= 500) {
            type = ErrorType.server;
          }
          break;
        default:
          type = ErrorType.unknown;
      }
    } else {
      // For any other exception (including connection errors that aren't DioException)
      type = ErrorType.network;
    }

    return ApiError(
      type: type,
      details: error is DioException ? error.response?.data : {'error': error.toString()},
    );
  }

  @override
  String toString() => type.toString();
}