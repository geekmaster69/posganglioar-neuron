import '../../domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);
  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(Map<String, dynamic> data) {
    return datasource.login(data);
  }

  @override
  Future<User> registerUser(Map<String, dynamic> data) {
    return datasource.registerUser(data);
  }
}
