import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/network/dio_client.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class NotificationApiService {
  Future<Either<ApiError, dynamic>> getPreferences();
  Future<Either<ApiError, dynamic>> updatePreferences(Map<String, dynamic> preferences);
  Future<Either<ApiError, dynamic>> registerDevice(String deviceToken, String deviceType);
  Future<Either<ApiError, dynamic>> unregisterDevice(String deviceToken);
  Future<Either<ApiError, dynamic>> sendTestNotification();
}

class NotificationApiServiceImpl implements NotificationApiService {
  @override
  Future<Either<ApiError, dynamic>> getPreferences() async {
    try {
      var response = await sl<DioClient>().get('${ApiUrl.baseURL}api/notifications/preferences/');
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> updatePreferences(Map<String, dynamic> preferences) async {
    try {
      var response = await sl<DioClient>().put(
        '${ApiUrl.baseURL}api/notifications/preferences/',
        data: preferences,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> registerDevice(String deviceToken, String deviceType) async {
    try {
      var response = await sl<DioClient>().post(
        '${ApiUrl.baseURL}api/notifications/register-device/',
        data: {
          'device_token': deviceToken,
          'device_type': deviceType,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> unregisterDevice(String deviceToken) async {
    try {
      var response = await sl<DioClient>().delete(
        '${ApiUrl.baseURL}api/notifications/unregister-device/',
        data: {'device_token': deviceToken},
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> sendTestNotification() async {
    try {
      var response = await sl<DioClient>().post(
        '${ApiUrl.baseURL}api/notifications/send-test/',
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ApiError.fromDioException(e));
    }
  }
}
