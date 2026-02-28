import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/shared/sources/time_api_service.dart';
import 'package:unisa_eat_2/service_locator.dart';

abstract class TimeRepository {
  Future<Either<ApiError, DateTime>> getServerTime();
}

class TimeRepositoryImpl implements TimeRepository {
  @override
  Future<Either<ApiError, DateTime>> getServerTime() async {
    var result = await sl<TimeApiService>().getServerTime();
    return result.fold(
      (error) => Left(error),
      (data) {
        try {
          DateTime serverTime = DateTime.parse(data['server_time']);
          return Right(serverTime);
        } catch (e) {
          return Left(ApiError(type: ErrorType.validation));
        }
      },
    );
  }
}