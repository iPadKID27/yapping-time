import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);

    // Listen to auth state changes and emit appropriate states
    authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));  // Emit directly, don't add event
      } else {
        emit(AuthUnauthenticated());
      }
    });

    // Check initial auth state
    add(AuthCheckRequested());
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) {
    final user = authService.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signInWithEmailAndPassword(event.email, event.password);
      // Don't emit here - let the authStateChanges listener handle it
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated()); // Go back to unauthenticated on error
    }
  }

  Future<void> _onSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signUpWithEmailAndPassword(event.email, event.password);
      // Don't emit here - let the authStateChanges listener handle it
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated()); // Go back to unauthenticated on error
    }
  }

  Future<void> _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authService.signOut();
    // The authStateChanges listener will emit AuthUnauthenticated
  }
}