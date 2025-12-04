import 'package:candy_tracker/config/config.dart';
import 'package:dio/dio.dart';

import '../../domain/domain.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final Dio dio;

  AuthDatasourceImpl() : dio = Dio(BaseOptions(baseUrl: Environments.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        Environments.checkStatus,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return User.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<User> login(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(Environments.loginPath, data: data);

      return User.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<User> registerUser(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(Environments.register, data: data);

      return User.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
