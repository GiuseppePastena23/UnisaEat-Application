import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';
import 'package:unisa_eat_2/data/affluence/repositories/affluence_repository.dart';

abstract class GetAffluenceUsecase {
  Future<Either<String, AffluenceModel>> call();
}

class GetAffluenceUsecaseImpl implements GetAffluenceUsecase {
  final AffluenceRepository repository;

  GetAffluenceUsecaseImpl(this.repository);

  @override
  Future<Either<String, AffluenceModel>> call() async {
    return await repository.getAffluence();
  }
}