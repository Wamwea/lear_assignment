import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    required this.status,
    this.user,
    this.error,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(Supabase.instance.client);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final logger = Logger('AuthNotifier');

  AuthNotifier(this._authService)
      : super(AuthState(
          status: AuthStatus.loading,
          user: _authService.currentUser,
        )) {
    _init();
  }

  void _init() {
    logger.info('Initializing AuthNotifier');
    _authService.authStateChanges.listen((event) {
      logger.info('Auth state changed: ${event.session?.user}');
      state = state.copyWith(
        user: event.session?.user,
        status: event.session?.user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      );
    });
  }

  Future<void> signIn(String email, String password) async {
    logger.info('Signing In with Email: $email , password: $password');
    try {
      state = state.copyWith(
        status: AuthStatus.loading,
        error: null,
      );

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      logger.info('User signed in successfully');
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        status: AuthStatus.unauthenticated,
      );
      logger.severe('User signed in failed: ${e.toString()}');
      return;
    }
  }

  Future<void> signUp(String email, String password) async {
    logger.info('Signing Up with Email: $email , password: $password');
    try {
      state = state.copyWith(
        status: AuthStatus.loading,
        error: null,
      );

      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        error: null,
      );
      logger.info('User signed up successfully');
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        status: AuthStatus.unauthenticated,
      );
      logger.severe('User Signup Failed: ${e.toString()}');
      return;
    }
  }

  Future<void> signOut() async {
    logger.info('Signing out');
    try {
      await _authService.signOut();
      logger.info('User signed out successfully');
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}
