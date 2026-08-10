class AuthResultModel {
  AuthResultModel({
    required this.token,
    required this.userId,
    this.name,
    this.email,
  });

  final String token;
  final String userId;
  final String? name;
  final String? email;

  factory AuthResultModel.fromJson(Map<String, dynamic> json) => AuthResultModel(
        token: json['token'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String?,
        email: json['email'] as String?,
      );
}

/// Returned after requesting a password reset — backend tells us whether
/// it sent an OTP (to verify in-app) or an email link (to just show a message).
class ForgotPasswordResultModel {
  ForgotPasswordResultModel({required this.method, this.maskedContact});

  /// "otp" or "email_link"
  final String method;
  final String? maskedContact;

  factory ForgotPasswordResultModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResultModel(
        method: json['method'] as String? ?? 'email_link',
        maskedContact: json['masked_contact'] as String?,
      );
}

/// Returned after OTP verification — short-lived token used to authorize
/// the actual password reset call, without re-sending the OTP.
class ResetTokenModel {
  ResetTokenModel({required this.resetToken});

  final String resetToken;

  factory ResetTokenModel.fromJson(Map<String, dynamic> json) =>
      ResetTokenModel(resetToken: json['reset_token'] as String);
}
