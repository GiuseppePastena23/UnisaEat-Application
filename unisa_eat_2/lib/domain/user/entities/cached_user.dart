import 'package:hive/hive.dart';
import 'package:unisa_eat_2/domain/user/entities/user_entity.dart';

part 'cached_user.g.dart';

const _ttl = Duration(hours: 24);

@HiveType(typeId: 1)  // Different typeId than UserEntity
class CachedUser {
  @HiveField(0)
  final UserEntity user;

  @HiveField(1)
  final DateTime expiry;

  CachedUser({
    required this.user,
    required this.expiry,
  });

  
  bool get isExpired => DateTime.now().isAfter(expiry);

  
  factory CachedUser.fromEntity(UserEntity userEntity) {
    return CachedUser(
      user: userEntity,
      expiry: DateTime.now().add(_ttl),
    );
  }

  @override
  String toString() => 'CachedUser{user: $user, expiry: $expiry, isExpired: $isExpired}';
}
