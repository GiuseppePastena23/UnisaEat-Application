import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class LoginUsecase extends Usecase<Either, LogInParams> {
  @override
  Future<Either> call({LogInParams? params}) async {
    
    return await sl<AuthRepository>().login(params!);
  }

} 