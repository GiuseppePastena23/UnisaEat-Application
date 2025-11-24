import 'package:dartz/dartz.dart';
import 'package:unisa_eat_2/common/helper/mapper/user_mapper.dart';
import 'package:unisa_eat_2/data/user/models/user_model.dart';
import 'package:unisa_eat_2/data/user/sources/user_api_service.dart';
import 'package:unisa_eat_2/domain/user/repositories/user_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';

class UserRepositoryImpl extends UserRepository {

  @override
  Future<Either> getUser() async {
    final result = await sl<UserApiService>().getUser();
    return await result.fold(
      (error) {
        return Left(error); 
      }, (data) async {
        final user = UserMapper.toEntity(UserModel.fromJson(data.data));
        return Right(user);
      }
    );
    
  }

}