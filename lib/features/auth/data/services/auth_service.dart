import 'package:contractor_app/core/network/api_client.dart';
import 'package:contractor_app/core/network/api_endpoints.dart';
import 'package:contractor_app/core/network/api_request_builder.dart';
import 'package:contractor_app/core/network/header_interceptor.dart';
import '../models/auth_model.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  Future<AuthResultModel> login({
    required String email,
    required String password,
  }) async {
    final result = await ApiRequestBuilder<AuthResultModel>(
      method: baseUrl.post.method,
      path: ApiEndpoints.login,
      data: {'email': email, 'password': password},
      fromJson: (json) => AuthResultModel.fromJson(json as Map<String, dynamic>),
    ).execute();

    AuthTokenStore.instance.token = result.token;
    return result;
  }

  Future<void> logout() async {
    await ApiRequestBuilder<void>(
      method: baseUrl.post.method,
      path: ApiEndpoints.logout,
      fromJson: (_) {},
    ).execute();
    AuthTokenStore.instance.token = null;
  }

  /// Step 1: user enters their email/phone. Backend sends either an OTP
  /// or an email link, and tells us which so the UI can branch.
  Future<ForgotPasswordResultModel> forgotPassword(String emailOrPhone) {
    return ApiRequestBuilder<ForgotPasswordResultModel>(
      method: baseUrl.post.method,
      path: ApiEndpoints.forgotPassword,
      data: {'identifier': emailOrPhone},
      fromJson: (json) =>
          ForgotPasswordResultModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  /// Step 2 (only if method == "otp"): user enters the code they received.
  /// Returns a short-lived reset token used in step 3.
  Future<ResetTokenModel> verifyResetOtp({
    required String emailOrPhone,
    required String otp,
  }) {
    return ApiRequestBuilder<ResetTokenModel>(
      method: baseUrl.post.method,
      path: ApiEndpoints.verifyResetOtp,
      data: {'identifier': emailOrPhone, 'otp': otp},
      fromJson: (json) => ResetTokenModel.fromJson(json as Map<String, dynamic>),
    ).execute();
  }

  /// Step 3: user sets a new password. `resetToken` comes from either
  /// verifyResetOtp() above, or from the deep link if the backend sent an
  /// email link instead of an OTP.
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) {
    return ApiRequestBuilder<void>(
      method: baseUrl.post.method,
      path: ApiEndpoints.resetPassword,
      data: {'reset_token': resetToken, 'new_password': newPassword},
      fromJson: (_) {},
    ).execute();
  }

  /// Separate from forgot-password: logged-in user changing their own
  /// password from a settings screen, requires the current password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return ApiRequestBuilder<void>(
      method: baseUrl.post.method,
      path: ApiEndpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
      fromJson: (_) {},
    ).execute();
  }
}
