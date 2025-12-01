import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:unisa_eat_2/common/helper/mapper/user_mapper.dart';
import 'package:unisa_eat_2/core/configs/constants/hive_boxes.dart';
import 'package:unisa_eat_2/data/user/models/user_model.dart';
import 'package:unisa_eat_2/data/user/sources/user_api_service.dart';
import 'package:unisa_eat_2/domain/user/entities/cached_user.dart';
import 'package:unisa_eat_2/domain/user/repositories/user_repository.dart';
import 'package:unisa_eat_2/service_locator.dart';


const _userKey = HiveBoxes.user;

class UserRepositoryImpl extends UserRepository {

  @override
  Future<Either> getUser() async {
    final box = sl<Box<CachedUser>>();
    final cachedData = box.get(_userKey);

    if (cachedData != null && !cachedData.isExpired) {
      return Right(cachedData.user);
    }

    if (cachedData != null) {
      await box.delete(_userKey);
    }
  
    final result = await sl<UserApiService>().getUser();
    return await result.fold(
      (error) {
        return Left(error); 
      }, (data) async {
        final cachedUser = UserMapper.toCachedEntity(UserModel.fromJson(data.data));
        final user = UserMapper.toEntity(UserModel.fromJson(data.data));
        
        await box.put(_userKey, cachedUser);
        
        
        return Right(user);
      }
    );
    
  }

}