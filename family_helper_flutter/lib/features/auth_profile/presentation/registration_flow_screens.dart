import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/auth/auth_error_mapper.dart';
import '../../../core/auth/auth_input_validator.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/network/app_api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import 'auth_flow_scaffold.dart';

const _privacyPolicyFileName = 'Family_Helper_Политика_ПД.pdf';
const _termsOfUseFileName = 'Family_Helper_Пользовательское_соглашение.pdf';

class RegistrationEmailStepScreen extends StatefulWidget {
  const RegistrationEmailStepScreen({super.key});

  @override
  State<RegistrationEmailStepScreen> createState() =>
      _RegistrationEmailStepScreenState();
}

class _RegistrationEmailStepScreenState
    extends State<RegistrationEmailStepScreen> {
  final _emailController = TextEditingController();
  bool _acceptedLegalTerms = false;
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
      cardEyebrow: 'Create account',
      title: 'Start with your email',
      subtitle: 'We will send a verification code so you can continue safely.',
      stepIndex: 1,
      stepTotal: 3,
      error: _error,
      body: [
        AppTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          prefixIcon: const Icon(Icons.alternate_email_rounded),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        _RegistrationLegalConsent(
          accepted: _acceptedLegalTerms,
          enabled: !_isLoading,
          onChanged: (value) {
            setState(() {
              _acceptedLegalTerms = value ?? false;
            });
          },
          onOpenPrivacyPolicy: () => _openLegalDocument(_privacyPolicyFileName),
          onOpenTermsOfUse: () => _openLegalDocument(_termsOfUseFileName),
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
    final emailValidationError = AuthInputValidator.validateEmail(email);
    if (emailValidationError != null) {
      setState(() {
        _error = emailValidationError;
      });
      return;
    }
    if (!_acceptedLegalTerms) {
      setState(() {
        _error =
            'Accept the Terms of Use and Privacy Policy to create an account.';
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

  Future<void> _openLegalDocument(String fileName) async {
    final uri = _buildLegalDocumentUri(fileName);
    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Legal document link is not configured.')),
      );
      return;
    }

    try {
      final openedInApp = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
      if (openedInApp) {
        return;
      }
    } catch (_) {}

    final openedExternally = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!openedExternally && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the document link.')),
      );
    }
  }

  Uri? _buildLegalDocumentUri(String fileName) {
    if (!getIt.isRegistered<AppApiClient>()) {
      return null;
    }

    final apiUri = Uri.tryParse(getIt<AppApiClient>().client.host);
    if (apiUri == null) {
      return null;
    }

    final host = apiUri.host.toLowerCase();
    final resolvedHost = switch (host) {
      'localhost' || '127.0.0.1' || '10.0.2.2' || '::1' => apiUri.host,
      _ when host.startsWith('api.') => 'app.${apiUri.host.substring(4)}',
      _ when host.startsWith('api-') => 'app-${apiUri.host.substring(4)}',
      _ => apiUri.host,
    };
    final resolvedPort = switch (apiUri.port) {
      8080 => 8082,
      0 => null,
      _ => apiUri.hasPort ? apiUri.port : null,
    };

    return apiUri.replace(
      host: resolvedHost,
      port: resolvedPort,
      pathSegments: ['legal', fileName],
      queryParameters: null,
      fragment: null,
    );
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
        cardEyebrow: 'Create account',
        title: 'Missing registration context',
        subtitle: 'Please restart registration from the first step.',
        stepIndex: 1,
        stepTotal: 3,
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
      cardEyebrow: 'Create account',
      title: 'Check your inbox',
      subtitle:
          'Enter the verification code to continue setting up your space.',
      stepIndex: 2,
      stepTotal: 3,
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
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(Icons.mark_email_read_rounded),
          onSubmitted: (_) => _submit(),
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
        cardEyebrow: 'Create account',
        title: 'Missing registration context',
        subtitle: 'Please restart registration from the first step.',
        stepIndex: 1,
        stepTotal: 3,
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
      cardEyebrow: 'Create account',
      title: 'Create your password',
      subtitle: 'One last step and your family space is ready to use.',
      stepIndex: 3,
      stepTotal: 3,
      error: _error,
      body: [
        AppTextField(
          controller: _passwordController,
          label: 'Password',
          obscureText: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          onSubmitted: (_) => _submit(),
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
    final passwordValidationError = AuthInputValidator.validatePassword(
      password,
    );
    if (passwordValidationError != null) {
      setState(() {
        _error = passwordValidationError;
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
    required this.cardEyebrow,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.stepIndex,
    required this.stepTotal,
    this.error,
  });

  final String cardEyebrow;
  final String title;
  final String subtitle;
  final String? error;
  final List<Widget> body;
  final int stepIndex;
  final int stepTotal;

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      cardEyebrow: cardEyebrow,
      cardTitle: title,
      cardSubtitle: subtitle,
      progressStep: stepIndex,
      progressTotal: stepTotal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...body,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: error == null
                ? const SizedBox.shrink()
                : Padding(
                    key: ValueKey(error),
                    padding: const EdgeInsets.only(top: 12),
                    child: AppBanner(text: error!, isError: true),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationLegalConsent extends StatelessWidget {
  const _RegistrationLegalConsent({
    required this.accepted,
    required this.enabled,
    required this.onChanged,
    required this.onOpenPrivacyPolicy,
    required this.onOpenTermsOfUse,
  });

  final bool accepted;
  final bool enabled;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onOpenPrivacyPolicy;
  final VoidCallback onOpenTermsOfUse;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: accepted,
      onChanged: enabled ? onChanged : null,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text(
        'I accept the Terms of Use and Privacy Policy.',
      ),
      subtitle: Wrap(
        spacing: 4,
        runSpacing: 0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Read the documents:',
            style: TextStyle(color: context.colors.textSecondary),
          ),
          TextButton(
            onPressed: onOpenTermsOfUse,
            child: const Text('Terms of Use'),
          ),
          Text(
            'and',
            style: TextStyle(color: context.colors.textSecondary),
          ),
          TextButton(
            onPressed: onOpenPrivacyPolicy,
            child: const Text('Privacy Policy'),
          ),
        ],
      ),
    );
  }
}
