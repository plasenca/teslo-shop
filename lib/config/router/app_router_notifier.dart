import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart'
    show AuthNotifier, AuthStatus, authProvider;

final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);

  return GoRouterNotifier(authNotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
