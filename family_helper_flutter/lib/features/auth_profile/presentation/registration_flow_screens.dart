import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_error_mapper.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';

class RegistrationEmailStepScreen extends StatefulWidget {
  const RegistrationEmailStepScreen({super.key});

  @override
  State<RegistrationEmailStepScreen> createState() =>
      _RegistrationEmailStepScreenState();
}

class _RegistrationEmailStepScreenState
    extends State<RegistrationEmailStepScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RegistrationStepScaffold(
      title: 'Create account',
      subtitle: 'Step 1 of 3: enter your email',
      error: _error,
      body: [
        AppTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Continue',
          isLoading: _isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Back to sign in',
          variant: AppButtonVariant.secondary,
          onPressed: _isLoading ? null : () => context.go(AppRoutes.signIn),
        ),
      ],
    );
  }

  Future<void> _submit() async {
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
      final requestId = await context.read<AuthCubit>().startRegistration(
        email: email,
      );
      if (!mounted) return;
      context.go(
        Uri(
          path: AppRoutes.registerCode,
          queryParameters: {
            'email': email,
            'requestId': requestId.uuid,
          },
        ).toString(),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'authUi.registration.start',
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
  }
}

class RegistrationCodeStepScreen extends StatefulWidget {
  const RegistrationCodeStepScreen({
    required this.email,
    required this.requestId,
    super.key,
  });

  final String? email;
  final String? requestId;

  @override
  State<RegistrationCodeStepScreen> createState() =>
      _RegistrationCodeStepScreenState();
}

class _RegistrationCodeStepScreenState
    extends State<RegistrationCodeStepScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    final requestId = widget.requestId;

    if (email == null ||
        email.isEmpty ||
        requestId == null ||
        requestId.isEmpty) {
      return _RegistrationStepScaffold(
        title: 'Create account',
        subtitle: 'Missing registration context',
        error: 'Please restart registration from step 1.',
        body: [
          AppButton(
            label: 'Go to step 1',
            onPressed: () => context.go(AppRoutes.registerEmail),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Back to sign in',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.go(AppRoutes.signIn),
          ),
        ],
      );
    }

    return _RegistrationStepScaffold(
      title: 'Create account',
      subtitle: 'Step 2 of 3: enter verification code',
      error: _error,
      body: [
        Text(
          'Code sent to $email',
          style: TextStyle(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _codeController,
          label: 'Verification code',
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Continue',
          isLoading: _isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Back',
          variant: AppButtonVariant.secondary,
          onPressed: _isLoading
              ? null
              : () => context.go(AppRoutes.registerEmail),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final requestId = widget.requestId;
    final email = widget.email;
    final code = _codeController.text.trim();

    if (requestId == null ||
        requestId.isEmpty ||
        email == null ||
        email.isEmpty) {
      setState(() {
        _error = 'Registration context is missing. Restart from step 1.';
      });
      return;
    }
    if (code.isEmpty) {
      setState(() {
        _error = 'Verification code is required';
      });
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final registrationToken = await context
          .read<AuthCubit>()
          .verifyRegistrationCodeByRequestId(
            accountRequestId: requestId,
            verificationCode: code,
          );
      if (!mounted) return;
      context.go(
        Uri(
          path: AppRoutes.registerPassword,
          queryParameters: {
            'email': email,
            'token': registrationToken,
          },
        ).toString(),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'authUi.registration.verifyCode',
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
  }
}

class RegistrationPasswordStepScreen extends StatefulWidget {
  const RegistrationPasswordStepScreen({
    required this.email,
    required this.registrationToken,
    super.key,
  });

  final String? email;
  final String? registrationToken;

  @override
  State<RegistrationPasswordStepScreen> createState() =>
      _RegistrationPasswordStepScreenState();
}

class _RegistrationPasswordStepScreenState
    extends State<RegistrationPasswordStepScreen> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registrationToken = widget.registrationToken;

    if (registrationToken == null || registrationToken.isEmpty) {
      return _RegistrationStepScaffold(
        title: 'Create account',
        subtitle: 'Missing registration context',
        error: 'Please restart registration from step 1.',
        body: [
          AppButton(
            label: 'Go to step 1',
            onPressed: () => context.go(AppRoutes.registerEmail),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Back to sign in',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.go(AppRoutes.signIn),
          ),
        ],
      );
    }

    return _RegistrationStepScaffold(
      title: 'Create account',
      subtitle: 'Step 3 of 3: create password',
      error: _error,
      body: [
        AppTextField(
          controller: _passwordController,
          label: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Create account',
          isLoading: _isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Start over',
          variant: AppButtonVariant.secondary,
          onPressed: _isLoading
              ? null
              : () => context.go(AppRoutes.registerEmail),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final registrationToken = widget.registrationToken;
    final password = _passwordController.text;

    if (registrationToken == null || registrationToken.isEmpty) {
      setState(() {
        _error = 'Registration context is missing. Restart from step 1.';
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        _error = 'Password is required';
      });
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      await context.read<AuthCubit>().finishRegistrationWithToken(
        registrationToken: registrationToken,
        password: password,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'authUi.registration.finish',
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
  }
}

class _RegistrationStepScaffold extends StatelessWidget {
  const _RegistrationStepScaffold({
    required this.title,
    required this.subtitle,
    required this.body,
    this.error,
  });

  final String title;
  final String subtitle;
  final String? error;
  final List<Widget> body;

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(color: colors.textSecondary),
                ),
                const SizedBox(height: 24),
                ...body,
                if (error != null) ...[
                  const SizedBox(height: 12),
                  AppBanner(text: error!, isError: true),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
