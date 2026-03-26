import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/auth_profile/presentation/auth_flow_scaffold.dart';
import 'package:family_helper_flutter/features/auth_profile/presentation/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject({
    SignInAction? onSignIn,
    Future<Object> Function(String email)? onStartPasswordReset,
    Future<void> Function(
      Object requestId,
      String verificationCode,
      String newPassword,
    )?
    onFinishPasswordReset,
  }) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: SignInScreen(
        onSignIn: onSignIn,
        onStartPasswordReset: onStartPasswordReset,
        onFinishPasswordReset: onFinishPasswordReset,
      ),
    );
  }

  testWidgets('uses compact auth layout on narrow screens', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(390, 844));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle(const Duration(milliseconds: 900));

    expect(find.byKey(AuthFlowScaffold.compactLayoutKey), findsOneWidget);
    expect(find.byKey(AuthFlowScaffold.wideLayoutKey), findsNothing);
    expect(find.text('Family Helper'), findsOneWidget);
    expect(find.text('Sign in to your family space'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses split auth layout on wide screens', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1280, 960));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle(const Duration(milliseconds: 900));

    expect(find.byKey(AuthFlowScaffold.wideLayoutKey), findsOneWidget);
    expect(find.byKey(AuthFlowScaffold.compactLayoutKey), findsNothing);
    expect(find.text('Calm planning for busy families.'), findsOneWidget);
  });

  testWidgets('shows inline sign-in errors inside the animated banner area', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(430, 960));

    await tester.pumpWidget(
      buildSubject(
        onSignIn: (email, password) async {
          expect(email, 'user@example.com');
          expect(password, 'wrong-password');
          throw Exception('invalid credentials');
        },
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 900));

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrong-password');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password.'), findsOneWidget);
  });

  testWidgets('password reset flow progresses through both modal steps', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(430, 960));

    Object? capturedRequestId;
    String? capturedCode;
    String? capturedPassword;

    await tester.pumpWidget(
      buildSubject(
        onStartPasswordReset: (email) async {
          expect(email, 'user@example.com');
          return Object();
        },
        onFinishPasswordReset:
            (requestId, verificationCode, newPassword) async {
              capturedRequestId = requestId;
              capturedCode = verificationCode;
              capturedPassword = newPassword;
            },
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 900));

    await tester.ensureVisible(find.text('Forgot password?'));
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    const emailStepKey = ValueKey('password-reset-step-email');
    const verifyStepKey = ValueKey('password-reset-step-verify');

    expect(find.byKey(emailStepKey), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byKey(emailStepKey),
        matching: find.byType(TextField),
      ),
      'user@example.com',
    );
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();

    expect(find.byKey(verifyStepKey), findsOneWidget);

    final verifyFields = find.descendant(
      of: find.byKey(verifyStepKey),
      matching: find.byType(TextField),
    );
    await tester.enterText(verifyFields.at(0), '246810');
    await tester.enterText(verifyFields.at(1), 'new-secret');
    await tester.ensureVisible(find.text('Update password'));
    await tester.tap(find.text('Update password'));
    await tester.pumpAndSettle();

    expect(capturedRequestId, isNotNull);
    expect(capturedCode, '246810');
    expect(capturedPassword, 'new-secret');
    expect(find.text('Password has been reset.'), findsOneWidget);
  });

  testWidgets('password reset errors stay inline inside the modal flow', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(430, 960));

    await tester.pumpWidget(
      buildSubject(
        onStartPasswordReset: (_) async => Object(),
        onFinishPasswordReset:
            (
              requestId,
              verificationCode,
              newPassword,
            ) async {
              expect(requestId, isNotNull);
              expect(verificationCode, 'bad-code');
              expect(newPassword, 'new-secret');
              throw Exception('invalid verification code');
            },
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 900));

    await tester.ensureVisible(find.text('Forgot password?'));
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    const emailStepKey = ValueKey('password-reset-step-email');
    const verifyStepKey = ValueKey('password-reset-step-verify');

    await tester.enterText(
      find.descendant(
        of: find.byKey(emailStepKey),
        matching: find.byType(TextField),
      ),
      'user@example.com',
    );
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();

    final verifyFields = find.descendant(
      of: find.byKey(verifyStepKey),
      matching: find.byType(TextField),
    );
    await tester.enterText(verifyFields.at(0), 'bad-code');
    await tester.enterText(verifyFields.at(1), 'new-secret');
    await tester.ensureVisible(find.text('Update password'));
    await tester.tap(find.text('Update password'));
    await tester.pumpAndSettle();

    expect(find.byKey(verifyStepKey), findsOneWidget);
    expect(
      find.text('Verification code error. Check the code and try again.'),
      findsOneWidget,
    );
    expect(find.text('Sign in to your family space'), findsOneWidget);
  });
}
