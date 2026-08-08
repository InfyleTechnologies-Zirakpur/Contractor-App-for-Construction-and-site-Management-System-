import '../models/user_model.dart';

/// Repository = the ONLY layer that knows where data comes from
/// (a mock, a REST API, SQLite, whatever). The Bloc never talks to a
/// server directly — it talks to this interface. That means:
///   1. You can swap mock -> real API later by editing ONLY this file.
///   2. You can unit-test the Bloc by injecting a fake repository.
///
/// TODO(you): replace the body of login() with a real http/dio call, e.g.
///   final res = await dio.post('/auth/login', data: {...});
///   return UserModel.fromJson(res.data);
class AuthRepository {
  Future<UserModel> login({required String phone, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    if (phone.trim().isEmpty || password.trim().isEmpty) {
      throw AuthException('Phone and password are required');
    }
    if (password.length < 4) {
      throw AuthException('Invalid phone number or password');
    }

    return UserModel(
      id: 'W-1029',
      name: 'Ramesh Kumar',
      phone: phone,
      role: 'Mason',
      siteName: 'Skyline Residency – Tower B',
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
