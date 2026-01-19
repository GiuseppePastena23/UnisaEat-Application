import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/core/usecase/usecase.dart';
import 'package:unisa_eat_2/domain/user/repositories/user_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class GetUserParams {
  final bool forceRefresh;

  const GetUserParams({this.forceRefresh = false});
}

class GetUserUsecase extends Usecase<Either, GetUserParams> {
  @override
  Future<Either> call({GetUserParams? params}) async{
    final forceRefresh = params?.forceRefresh ?? false;
    return await sl<UserRepository>().getUser(forceRefresh: forceRefresh);
  }
}