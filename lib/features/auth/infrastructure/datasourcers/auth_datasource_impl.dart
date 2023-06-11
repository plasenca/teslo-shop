import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart' show Environment;

import 'package:teslo_shop/features/auth/domain/domain.dart'
    show AuthDatasource, User;
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart'
    show
        UserMapper,
        WrongCredentials,
        ConnectionTimeOut,
        CustomError,
        TokenNotValid;

class AuthDataSourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final user = UserMapper.userJsonToEntity(response.data);

      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw TokenNotValid();
      }

      if (e.type == DioErrorType.connectionTimeout) {
        throw ConnectionTimeOut();
      }

      throw CustomError(
        statusCode: e.response?.statusCode ?? 1,
        message: e.response?.statusMessage ?? 'Error no controlado',
      );
    } catch (e) {
      throw CustomError(
        statusCode: 1,
        message: 'Error no controlado',
      );
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);

      return user;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) throw ConnectionTimeOut();

      if (e.response?.statusCode == 401) throw WrongCredentials();

      throw CustomError(
        statusCode: e.response?.statusCode ?? 1,
        message: e.response?.statusMessage ?? 'Error no controlado',
      );
    } catch (e) {
      throw CustomError(
        statusCode: 1,
        message: 'Error no controlado',
      );
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
