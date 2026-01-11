import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/data/auth/sources/auth_api_service.dart';
import 'package:unisa_eat_2/core/configs/constants/api_url.dart';

import 'package:unisa_eat_2/service_locator.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  Logger logger = sl<Logger>();

  @override
  void onError( DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request ==> $requestPath'); //Error log
    logger.d('Error type: ${err.error} \n '
        'Error message: ${err.message}'); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request ==> $requestPath'); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('STATUSCODE: ${response.statusCode} \n '
        'STATUSMESSAGE: ${response.statusMessage} \n'
        'HEADERS: ${response.headers} \n'
        'Data: ${response.data}'); // Debug log
    handler.next(response); // continue with the Response
  }

  
}

class TokenInterceptor extends Interceptor{

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async{

    final token = await sl<AuthService>().getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await sl<AuthService>().getRefreshToken();
      if (refreshToken != null) {
        try {
          final result = await sl<AuthApiService>().refresh(refreshToken);
          result.fold(
            (error) {
              // Refresh failed, continue with error
              handler.next(err);
            },
            (data) async {
              // Update tokens
              sl<AuthService>().setAccessToken(data.data['access_token']);
              sl<AuthService>().setRefreshToken(data.data['refresh_token']);
              // Retry the request
              final newToken = await sl<AuthService>().getAccessToken();
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final dio = Dio(BaseOptions(baseUrl: ApiUrl.baseURL));
              try {
                final response = await dio.fetch(err.requestOptions);
                handler.resolve(response);
              } catch (e) {
                handler.next(err);
              }
            }
          );
        } catch (e) {
          handler.next(err);
        }
      } else {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
