import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_error_mapper.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import 'auth_flow_scaffold.dart';
import 'password_reset_flow_sheet.dart';

typedef SignInAction = Future<void> Function(String email, String password);

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    this.onSignIn,
    this.onStartPasswordReset,
    this.onFinishPasswordReset,
  });

  final SignInAction? onSignIn;
  final PasswordResetStart? onStartPasswordReset;
  final PasswordResetFinish? onFinishPasswordReset;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      cardEyebrow: 'Welcome back',
      cardTitle: 'Sign in to your family space',
      cardSubtitle:
          'Pick up where you left off with your shared plans, tasks, and goals.',
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _error == null
                  ? const SizedBox.shrink()
                  : Padding(
                      key: ValueKey(_error),
                      padding: const EdgeInsets.only(bottom: 14),
                      child: AppBanner(text: _error!, isError: true),
                    ),
            ),
            AppTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
              ],
              prefixIcon: const Icon(Icons.alternate_email_rounded),
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
              ),
              onSubmitted: (_) => _submitSignIn(),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLoading ? null : _showPasswordResetFlow,
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Sign in',
              isLoading: _isLoading,
              onPressed: _submitSignIn,
            ),
            const SizedBox(height: 16),
            _CreateAccountButton(
              isEnabled: !_isLoading,
              onPressed: () => context.go(AppRoutes.registerEmail),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final validationError = _validate(email: email, password: password);
    if (validationError != null) {
      setState(() {
        _error = validationError;
      });
      return;
    }

    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext();

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final signIn =
          widget.onSignIn ??
          (String email, String password) {
            return context.read<AuthCubit>().signIn(
              email: email,
              password: password,
            );
          };
      await signIn(email, password);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'authUi.signIn',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _error = AuthErrorMapper.toMessage(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validate({
    required String email,
    required String password,
  }) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@')) {
      return 'Enter a valid email address';
    }
    if (password.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  Future<void> _showPasswordResetFlow() async {
    final authCubit = context.read<AuthCubit?>();
    final didReset = await PasswordResetFlowSheet.show(
      context,
      onStartPasswordReset:
          widget.onStartPasswordReset ??
          (String email) {
            if (authCubit == null) {
              throw StateError('AuthCubit is not available');
            }
            return authCubit.startPasswordReset(email: email);
          },
      onFinishPasswordReset:
          widget.onFinishPasswordReset ??
          (requestId, verificationCode, newPassword) {
            if (authCubit == null) {
              throw StateError('AuthCubit is not available');
            }
            return authCubit.finishPasswordReset(
              passwordResetRequestId: requestId as dynamic,
              verificationCode: verificationCode,
              newPassword: newPassword,
            );
          },
    );

    if (didReset == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password has been reset.')),
      );
    }
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return OutlinedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: const Icon(Icons.person_add_alt_1_rounded),
      label: const Text('Create account with email code'),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textPrimary,
        side: BorderSide(color: colors.border),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
