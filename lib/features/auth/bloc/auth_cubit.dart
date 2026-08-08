import 'package:contractor_app/features/auth/data/models/user_model.dart';
import 'package:contractor_app/features/auth/data/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

/// ============================ LEARNING NOTE ============================
/// CUBIT vs BLOC — what's the actual difference?
///
/// A Cubit is a Bloc with the "events" step removed. Instead of:
///   UI -> dispatches an Event -> Bloc maps Event to a new State
/// a Cubit just exposes plain methods:
///   UI -> calls cubit.login(...) -> cubit emits a new State directly
///
/// Both give you the same core things:
///   - a `state` (current value)
///   - a `Stream<State>` the UI can listen to
///   - emit(newState) to push updates
///
/// Use Cubit when: the state changes are simple, direct method calls
/// (login, logout, toggle, increment...) — no need to log/replay/queue
/// "events" as a formal concept.
///
/// Use Bloc when: you want a formal Event -> State pipeline. This shines
/// when multiple different triggers should update state in a structured,
/// traceable way (see AttendanceBloc below for the full Bloc version —
/// compare the two side by side).
/// =========================================================================
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  Future<void> login({required String phone, required String password}) async {
    emit(const AuthLoading()); // 1. tell the UI "we're working on it"
    try {
      final user = await _authRepository.login(phone: phone, password: password);
      emit(AuthAuthenticated(user)); // 2. success -> new state
    } on AuthException catch (e) {
      emit(AuthError(e.message)); // 3. failure -> error state
    } catch (_) {
      emit(const AuthError('Something went wrong. Please try again.'));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
