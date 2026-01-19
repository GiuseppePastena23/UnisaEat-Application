import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';

abstract class TimeRepository {
  Future<Either<ApiError, DateTime>> getServerTime();
}