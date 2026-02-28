import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/services/auth_service.dart';
import 'package:unisa_eat_2/core/services/notification_service.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/data/auth/models/register_params.dart';
import 'package:unisa_eat_2/data/notification/sources/notification_api_service.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/domain/auth/usecases/login.dart';
import 'package:unisa_eat_2/domain/auth/usecases/register.dart';
import 'package:unisa_eat_2/service_locator.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(LogInParams params) async {
    emit(LoginLoading());
    var result = await sl<LoginUsecase>().call(params: params);
    result.fold(
      (error) => emit(LoginFailure(error)),
      (data) async {
        // Save tokens
        sl<AuthService>().setAccessToken(data['access']);
        sl<AuthService>().setRefreshToken(data['refresh']);
        
        // Register device for push notifications
        await _registerDevice();
        
        emit(LoginSuccess());
      },
    );
  }

  Future<void> _registerDevice() async {
    try {
      final token = await NotificationService.getDeviceToken();
      if (token != null) {
        final notificationService = sl<NotificationApiService>();
        final result = await notificationService.registerDevice(token, 'android');
        result.fold(
          (error) => print('Failed to register device: $error'),
          (data) => print('Device registered successfully'),
        );
      }
    } catch (e) {
      print('Failed to register device: $e');
    }
  }

  Future<void> register(RegisterParams params) async {
    emit(LoginLoading());
    var result = await RegisterUsecase(sl<AuthRepository>()).call(params);
    result.fold(
      (error) => emit(LoginFailure(error)),
      (success) => emit(RegisterSuccess()),
    );
  }
}

