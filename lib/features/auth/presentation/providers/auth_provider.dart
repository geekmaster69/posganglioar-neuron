import 'package:candy_tracker/features/auth/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:candy_tracker/config/config.dart';
import 'package:candy_tracker/features/auth/domain/domain.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final keyValueStorageService = SharedPreferencesPlugin();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final SharedPreferencesPlugin keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }
  Future<void> loginUser(Map<String, dynamic> data) async {
    try {
      final user = await authRepository.login(data);

      await _setLoggedUser(user);
    } catch (e) {
      await logout('Error no controlado');
    }
  }

  Future<void> reloadUser() async {
    state = state.copyWith(authStatus: AuthStatus.checking, user: null);
    await checkAuthStatus();
  }

  Future<void> registerUser(Map<String, dynamic> data) async {
    try {
      final user = await authRepository.registerUser(data);
      await _setLoggedUser(user);
    } catch (e) {
      await logout('Unknown error');
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');

    if (token == null) {
      await logout();
      return;
    }

    try {
      final user = await authRepository.checkAuthStatus(token);
      await _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<void> _setLoggedUser(User user) async {
    await keyValueStorageService.setValue<String>('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage = '']) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

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
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
