import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/domain/auth/usecases/login.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_state.dart';
import 'package:unisa_eat_2/service_locator.dart';

class LoginCubit extends Cubit<LoginState>{
  LoginCubit() : super(LoginInitial());
  
  void login(LogInParams params) async {
    emit(LoginLoading());
    var userToken = await sl<LoginUsecase>().call(
      params: params,
    );
    userToken.fold(
      (error) {
        emit(LoginFailure(error));
      },
      (data) {
        emit(LoginSuccess(data.data['access_token']));
      },
    );
  }
}

