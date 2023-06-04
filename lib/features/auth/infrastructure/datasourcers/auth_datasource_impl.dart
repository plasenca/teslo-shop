import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart' show Environment;

import 'package:teslo_shop/features/auth/domain/domain.dart'
    show AuthDatasource, User;
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart'
    show UserMapper, WrongCredentials;

class AuthDataSourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      print(user);

      return user;
    } catch (e) {
      print(e);
      throw WrongCredentials();
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String fullname,
  }) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
