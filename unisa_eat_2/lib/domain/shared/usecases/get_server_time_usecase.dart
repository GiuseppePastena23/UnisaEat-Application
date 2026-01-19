import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/shared/repositories/time_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetServerTimeUsecase extends Usecase<Either<ApiError, DateTime>, void> {
  @override
  Future<Either<ApiError, DateTime>> call({void params}) async {
    return await sl<TimeRepository>().getServerTime();
  }
}