import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';
import 'package:unisa_eat_2/data/affluence/repositories/affluence_repository.dart';

abstract class GetAffluenceUsecase {
  Future<Either<ApiError, AffluenceModel>> call();
}

class GetAffluenceUsecaseImpl implements GetAffluenceUsecase {
  final AffluenceRepository repository;

  GetAffluenceUsecaseImpl(this.repository);

  @override
  Future<Either<ApiError, AffluenceModel>> call() async {
    return await repository.getAffluence();
  }
}