import 'package:teslo_shop/features/auth/domain/domain.dart'
    show AuthRepository, AuthDatasource, User;
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart'
    show AuthDataSourceImpl;

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({
    AuthDatasource? datasource,
  }) : datasource = datasource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<User> register(
      {required String email,
      required String password,
      required String fullname}) {
    return datasource.register(
      email: email,
      password: password,
      fullname: fullname,
    );
  }
}
