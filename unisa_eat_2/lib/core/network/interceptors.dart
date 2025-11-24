import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';

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

    final token = await sl<AuthService>().getToken();

    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    
    }
    
    super.onRequest(options, handler);
  }
}
