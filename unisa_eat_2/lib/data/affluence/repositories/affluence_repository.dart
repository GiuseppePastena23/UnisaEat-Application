import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/affluence/models/affluence_model.dart';
import 'package:unisa_eat_2/data/affluence/sources/affluence_api_service.dart';

abstract class AffluenceRepository {
  Future<Either<ApiError, AffluenceModel>> getAffluence();
}

class AffluenceRepositoryImpl implements AffluenceRepository {
  final AffluenceApiService apiService;

  AffluenceRepositoryImpl(this.apiService);

  @override
  Future<Either<ApiError, AffluenceModel>> getAffluence() async {
    return await apiService.getAffluence();
  }
}