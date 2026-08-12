import 'package:contractor_app/core/roles/app_role.dart';
import 'package:contractor_app/features/auth/data/models/auth_model.dart';

/// Demo auth responses returned while `AppConfig.mockMode` is true.
class AuthMock {
  AuthMock._();

  /// Accepts any non-empty credentials. An email containing "sub" (e.g.
  /// sub@demo.com) logs in as Sub-Contractor so both roles are demoable;
  /// anything else logs in as Contractor.
  static AuthResultModel login({required String email, required String password}) {
    final role = email.toLowerCase().contains('sub')
        ? AppRole.subContractor.apiValue
        : AppRole.contractor.apiValue;
    return AuthResultModel(
      token: 'demo-token',
      userId: 'usr-demo',
      name: email.split('@').first,
      email: email,
      role: role,
    );
  }

  static ForgotPasswordResultModel forgotPassword(String identifier) {
    return ForgotPasswordResultModel(
      method: 'otp',
      maskedContact: '••••${identifier.length > 3 ? identifier.substring(identifier.length - 3) : identifier}',
    );
  }

  static ResetTokenModel verifyResetOtp(String identifier, String otp) {
    return ResetTokenModel(resetToken: 'demo-reset-token');
  }
}