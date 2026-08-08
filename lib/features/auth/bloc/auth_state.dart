part of 'auth_cubit.dart';

/// A "state" is just: everything the UI needs to render itself, at one
/// point in time. We use a sealed class + subclasses instead of one class
/// with nullable fields — this way `switch`/`is` checks are exhaustive
/// and the compiler yells at you if you forget to handle a case.
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final UserModel user;
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
