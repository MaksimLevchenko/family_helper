import 'package:flutter/material.dart';

import '../../../core/auth/auth_error_mapper.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';

typedef PasswordResetStart = Future<Object> Function(String email);
typedef PasswordResetFinish =
    Future<void> Function(
      Object requestId,
      String verificationCode,
      String newPassword,
    );

class PasswordResetFlowSheet extends StatefulWidget {
  const PasswordResetFlowSheet({
    required this.onStartPasswordReset,
    required this.onFinishPasswordReset,
    super.key,
  });

  final PasswordResetStart onStartPasswordReset;
  final PasswordResetFinish onFinishPasswordReset;

  static Future<bool?> show(
    BuildContext context, {
    required PasswordResetStart onStartPasswordReset,
    required PasswordResetFinish onFinishPasswordReset,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PasswordResetFlowSheet(
          onStartPasswordReset: onStartPasswordReset,
          onFinishPasswordReset: onFinishPasswordReset,
        );
      },
    );
  }

  @override
  State<PasswordResetFlowSheet> createState() => _PasswordResetFlowSheetState();
}

enum _PasswordResetStep { email, verify }

class _PasswordResetFlowSheetState extends State<PasswordResetFlowSheet> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  _PasswordResetStep _step = _PasswordResetStep.email;
  Object? _requestId;
  String? _error;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return AppModalSheet(
      maxWidth: 560,
      showHandle: false,
      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reset password',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _step == _PasswordResetStep.email
                          ? 'We will send a verification code to your email.'
                          : 'Enter the code you received and choose a new password.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ResetProgress(step: _step),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _buildStepContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    final body = switch (_step) {
      _PasswordResetStep.email => _buildEmailStep(context),
      _PasswordResetStep.verify => _buildVerifyStep(context),
    };

    return KeyedSubtree(
      key: ValueKey(_step),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          body,
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _error == null
                ? const SizedBox.shrink()
                : AppBanner(
                    key: ValueKey(_error),
                    text: _error!,
                    isError: true,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailStep(BuildContext context) {
    return Column(
      key: const ValueKey('password-reset-step-email'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          prefixIcon: const Icon(Icons.alternate_email_rounded),
          onSubmitted: (_) => _submitEmailStep(),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: 'Send verification code',
          isLoading: _isLoading,
          onPressed: _submitEmailStep,
        ),
      ],
    );
  }

  Widget _buildVerifyStep(BuildContext context) {
    return Column(
      key: const ValueKey('password-reset-step-verify'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Code sent to ${_emailController.text.trim()}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _codeController,
          label: 'Verification code',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.mark_email_read_rounded),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _passwordController,
          label: 'New password',
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          prefixIcon: const Icon(Icons.lock_reset_rounded),
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
          onSubmitted: (_) => _submitVerifyStep(),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: 'Update password',
          isLoading: _isLoading,
          onPressed: _submitVerifyStep,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  setState(() {
                    _error = null;
                    _step = _PasswordResetStep.email;
                    _requestId = null;
                    _codeController.clear();
                    _passwordController.clear();
                  });
                },
          child: const Text('Start over'),
        ),
      ],
    );
  }

  Future<void> _submitEmailStep() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _error = 'Email is required';
      });
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final requestId = await widget.onStartPasswordReset(email);
      if (!mounted) {
        return;
      }
      setState(() {
        _requestId = requestId;
        _step = _PasswordResetStep.verify;
      });
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'authUi.passwordResetFlow.start',
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

  Future<void> _submitVerifyStep() async {
    final requestId = _requestId;
    final code = _codeController.text.trim();
    final newPassword = _passwordController.text;

    if (requestId == null) {
      setState(() {
        _error = 'Please restart the reset flow.';
      });
      return;
    }
    if (code.isEmpty) {
      setState(() {
        _error = 'Verification code is required';
      });
      return;
    }
    if (newPassword.isEmpty) {
      setState(() {
        _error = 'New password is required';
      });
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      await widget.onFinishPasswordReset(requestId, code, newPassword);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'authUi.passwordResetFlow.finish',
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
}

class _ResetProgress extends StatelessWidget {
  const _ResetProgress({required this.step});

  final _PasswordResetStep step;

  @override
  Widget build(BuildContext context) {
    final currentStep = switch (step) {
      _PasswordResetStep.email => 1,
      _PasswordResetStep.verify => 2,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $currentStep of 2',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: currentStep / 2,
            backgroundColor: context.colors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
          ),
        ),
      ],
    );
  }
}
