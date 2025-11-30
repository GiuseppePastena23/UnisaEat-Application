import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:unisa_eat_2/core/configs/constants/hive_boxes.dart';
import 'package:unisa_eat_2/domain/user/entities/cached_user.dart';
import 'package:unisa_eat_2/service_locator.dart';

class AuthService {

  final FlutterSecureStorage _storage;
  Logger logger = sl<Logger>();

  AuthService(this._storage);

  static const String _tokenKey = 'token';

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
  final token = await _storage.read(key: _tokenKey); 
  logger.d('Retrieved token: $token');
  return token;
}

  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final userBox = sl<Box<CachedUser>>();
    await userBox.delete(HiveBoxes.user);
    
    
    await _storage.delete(key: _tokenKey);
  }

}