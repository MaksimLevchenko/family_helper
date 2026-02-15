import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth_session.dart';
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
                    } catch (error) {
                      setState(() {
                        _error = '$error';
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
