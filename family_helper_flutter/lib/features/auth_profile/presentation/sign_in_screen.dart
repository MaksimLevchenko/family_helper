import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_error_mapper.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Family Helper',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(color: colors.textSecondary),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  AppBanner(text: _error!, isError: true),
                  const SizedBox(height: 12),
                ],
                AppButton(
                  label: 'Sign in',
                  isLoading: _isLoading,
                  onPressed: () async {
                    setState(() {
                      _error = null;
                      _isLoading = true;
                    });
                    try {
                      await context.read<AuthCubit>().signIn(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                      );
                    } catch (error, stackTrace) {
                      AppErrorLogger.logHandled(
                        scope: 'authUi.signIn',
                        error: error,
                        stackTrace: stackTrace,
                      );
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
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Create account (email code)',
                  variant: AppButtonVariant.secondary,
                  onPressed: _isLoading
                      ? null
                      : () => context.go(AppRoutes.registerEmail),
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: 'Reset password (email code)',
                  variant: AppButtonVariant.secondary,
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _runPasswordResetFlow();
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _runPasswordResetFlow() async {
    final authCubit = context.read<AuthCubit>();
    final messenger = ScaffoldMessenger.of(context);

    final email = await _askValue(
      context,
      title: 'Reset password',
      label: 'Email',
    );
    if (email == null || email.trim().isEmpty) {
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final requestId = await authCubit.startPasswordReset(
        email: email.trim(),
      );

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Password reset request created: ${requestId.uuid}'),
        ),
      );

      final code = await _askValue(
        context,
        title: 'Reset password',
        label: 'Verification code',
      );
      if (code == null || code.trim().isEmpty) {
        return;
      }

      if (!mounted) return;
      final newPassword = await _askValue(
        context,
        title: 'Reset password',
        label: 'New password',
        obscureText: true,
      );
      if (newPassword == null || newPassword.isEmpty) {
        return;
      }

      await authCubit.finishPasswordReset(
        passwordResetRequestId: requestId,
        verificationCode: code.trim(),
        newPassword: newPassword,
      );

      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Password has been reset.')),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'authUi.passwordResetFlow',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
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

  Future<String?> _askValue(
    BuildContext context, {
    required String title,
    required String label,
    bool obscureText = false,
  }) async {
    final controller = TextEditingController();
    try {
      return await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(labelText: label),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(controller.text),
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );
    } finally {
      controller.dispose();
    }
  }
}
