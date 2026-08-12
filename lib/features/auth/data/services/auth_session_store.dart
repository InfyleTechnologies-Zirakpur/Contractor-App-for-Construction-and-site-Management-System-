import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/roles/app_role.dart';
import '../../../../core/network/header_interceptor.dart';

/// Persists the authenticated session (token, role, basic profile) in
/// SharedPreferences so the app survives restarts. This is the single source
/// of truth for "who is logged in"; [AuthTokenStore] is only the in-memory
/// value the network interceptor reads, and is kept in sync here.
class AuthSessionStore {
  AuthSessionStore._();
  static final AuthSessionStore instance = AuthSessionStore._();

  static const _tokenKey = 'auth_token';
  static const _roleKey = 'auth_role';
  static const _nameKey = 'auth_name';
  static const _emailKey = 'auth_email';

  String? _token;
  AppRole? _role;
  String? _name;
  String? _email;

  bool get isLoggedIn => _token != null;
  String? get token => _token;

  /// Present after a successful login; falls back to the primary role if the
  /// backend didn't send one yet (still TODO).
  AppRole get role => _role ?? AppRole.contractor;
  String? get name => _name;
  String? get email => _email;

  /// Restore a saved session at app startup. Safe to call even when none
  /// exists; returns true when a token was restored as the active session.
  Future<bool> restore() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _role = AppRole.fromString(prefs.getString(_roleKey));
    _name = prefs.getString(_nameKey);
    _email = prefs.getString(_emailKey);

    if (_token != null) {
      AuthTokenStore.instance.token = _token;
      return true;
    }
    return false;
  }

  Future<void> save({
    required String token,
    required AppRole role,
    String? name,
    String? email,
  }) async {
    _token = token;
    _role = role;
    _name = name;
    _email = email;
    AuthTokenStore.instance.token = token;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role.apiValue);
    if (name != null) await prefs.setString(_nameKey, name);
    if (email != null) await prefs.setString(_emailKey, email);
  }

  Future<void> clear() async {
    _token = null;
    _role = null;
    _name = null;
    _email = null;
    AuthTokenStore.instance.token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
  }
}