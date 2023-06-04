import 'package:teslo_shop/features/auth/domain/domain.dart'
    show AuthDatasource;
import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class AuthDataSourceImpl extends AuthDatasource {
  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
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
