import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/auth/models/register_params.dart';
import 'package:unisa_eat_2/domain/auth/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<ApiError, dynamic>> call(RegisterParams params) async {
    return await repository.register(params);
  }
}