import 'package:contractor_app/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'verify_reset_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    final identifier = _controller.text.trim();
    if (identifier.isEmpty) {
      setState(() => _error = 'Enter your registered email or phone number');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await AuthService.instance.forgotPassword(identifier);

      if (!mounted) return;

      if (result.method == 'otp') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerifyResetOtpScreen(
              identifier: identifier,
              maskedContact: result.maskedContact,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check your email for a link to reset your password.'),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      setState(() => _error = "We couldn't find an account with that detail.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the email or phone number linked to your account. '
              "We'll send you a code to reset your password.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Email or phone number',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.statusRejected)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Send reset code'),
            ),
          ],
        ),
      ),
    );
  }
}
