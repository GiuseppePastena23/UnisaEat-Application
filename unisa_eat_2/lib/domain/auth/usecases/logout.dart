import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class LogoutUsecase extends Usecase<void, void> {
  @override
  Future<void> call({void params}) async {
    
    return await sl<AuthRepository>().logout();
  }

} 