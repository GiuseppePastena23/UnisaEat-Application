import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';
import 'package:unisa_eat_2/data/affluence/sources/affluence_api_service.dart';

abstract class AffluenceRepository {
  Future<Either<String, AffluenceModel>> getAffluence();
}

class AffluenceRepositoryImpl implements AffluenceRepository {
  final AffluenceApiService apiService;

  AffluenceRepositoryImpl(this.apiService);

  @override
  Future<Either<String, AffluenceModel>> getAffluence() async {
    return await apiService.getAffluence();
  }
}