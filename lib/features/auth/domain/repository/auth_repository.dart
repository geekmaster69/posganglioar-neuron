import '../domain.dart';

abstract class AuthRepository {
  Future<User> registerUser(Map<String, dynamic> data);

  Future<User> login(Map<String, dynamic> data);

  Future<User> checkAuthStatus(String token);
}
