import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/auth/domain/domain.dart'
    show User, AuthRepository;
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/domain/domain.dart'
    show KeyValueStorageService;
import 'package:teslo_shop/features/shared/infrastructure/infrastructure.dart'
    show SharedPreferencesImplService;

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = SharedPreferencesImplService();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales no son correctas');
    } on ConnectionTimeOut {
      logout('Tiempo de espera agotado');
    } catch (e) {
      logout('Error no controlado');
    }
  }

  Future<void> registerUser(String email, String password) async {}

  Future<void> checkAuthStatus() async {}

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.remove('token');

    state = state.copyWith(
      authStatus: AuthStatus.unAuthenticated,
      errorMessage: errorMessage,
      user: null,
    );
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }
}

enum AuthStatus { checking, authenticated, unAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
