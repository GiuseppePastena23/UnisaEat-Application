import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {

  final FlutterSecureStorage _storage;

  AuthService(this._storage);

  static const String _tokenKey = 'token';

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
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
    await _storage.delete(key: _tokenKey);
  }

}