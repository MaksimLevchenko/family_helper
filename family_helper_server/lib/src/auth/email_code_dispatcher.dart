import 'dart:async';

import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

enum EmailCodeKind { registration, passwordReset }

abstract interface class EmailCodeSender {
  Future<void> sendCode({
    required String recipientEmail,
    required String verificationCode,
    required EmailCodeKind kind,
  });
}

class SmtpEmailCodeSender implements EmailCodeSender {
  SmtpEmailCodeSender({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.fromEmail,
    required this.fromName,
    required this.useSsl,
    required this.allowInsecure,
  });

  final String host;
  final int port;
  final String username;
  final String password;
  final String fromEmail;
  final String fromName;
  final bool useSsl;
  final bool allowInsecure;

  @override
  Future<void> sendCode({
    required String recipientEmail,
    required String verificationCode,
    required EmailCodeKind kind,
  }) async {
    final server = SmtpServer(
      host,
      port: port,
      username: username,
      password: password,
      ssl: useSsl,
      allowInsecure: allowInsecure,
    );
    final message = mailer.Message()
      ..from = mailer.Address(fromEmail, fromName)
      ..recipients.add(recipientEmail)
      ..subject = _subject(kind)
      ..text = _text(kind, verificationCode);

    await mailer.send(message, server);
  }

  String _subject(EmailCodeKind kind) {
    switch (kind) {
      case EmailCodeKind.registration:
        return 'Family Helper registration code';
      case EmailCodeKind.passwordReset:
        return 'Family Helper password reset code';
    }
  }

  String _text(EmailCodeKind kind, String verificationCode) {
    switch (kind) {
      case EmailCodeKind.registration:
        return 'Use this code to verify your registration: $verificationCode';
      case EmailCodeKind.passwordReset:
        return 'Use this code to reset your password: $verificationCode';
    }
  }
}

final class EmailCodeDispatcher {
  const EmailCodeDispatcher({this.sender});

  static const _smtpHostKey = 'smtpHost';
  static const _smtpPortKey = 'smtpPort';
  static const _smtpUsernameKey = 'smtpUsername';
  static const _smtpPasswordKey = 'smtpPassword';
  static const _smtpFromEmailKey = 'smtpFromEmail';
  static const _smtpFromNameKey = 'smtpFromName';
  static const _smtpUseSslKey = 'smtpUseSsl';
  static const _smtpAllowInsecureKey = 'smtpAllowInsecure';

  static EmailCodeDispatcher instance = const EmailCodeDispatcher();

  final EmailCodeSender? sender;

  void sendRegistrationCode(
    Session session, {
    required String email,
    required String verificationCode,
  }) {
    _dispatch(
      session,
      email: email,
      verificationCode: verificationCode,
      kind: EmailCodeKind.registration,
    );
  }

  void sendPasswordResetCode(
    Session session, {
    required String email,
    required String verificationCode,
  }) {
    _dispatch(
      session,
      email: email,
      verificationCode: verificationCode,
      kind: EmailCodeKind.passwordReset,
    );
  }

  void _dispatch(
    Session session, {
    required String email,
    required String verificationCode,
    required EmailCodeKind kind,
  }) {
    final runMode = session.server.serverpod.runMode;
    final injectedSender = sender;
    final smtpSender = injectedSender ?? _buildSmtpSender(session);
    if (smtpSender == null ||
        (runMode == ServerpodRunMode.test && injectedSender == null)) {
      // Dev/test fallback when SMTP is not configured.
      session.log(
        '[EmailIdp] ${kind.name} code for $email: $verificationCode',
      );
      return;
    }

    unawaited(
      smtpSender
          .sendCode(
            recipientEmail: email,
            verificationCode: verificationCode,
            kind: kind,
          )
          .catchError((error, stackTrace) {
            session.log(
              '[EmailIdp] Failed to send ${kind.name} code to $email',
              level: LogLevel.error,
              exception: error,
              stackTrace: stackTrace is StackTrace
                  ? stackTrace
                  : StackTrace.current,
            );
          }),
    );
  }

  SmtpEmailCodeSender? _buildSmtpSender(Session session) {
    final passwords = session.passwords;
    final host = passwords[_smtpHostKey];
    final username = passwords[_smtpUsernameKey];
    final password = passwords[_smtpPasswordKey];
    final fromEmail = passwords[_smtpFromEmailKey];
    final fromName = passwords[_smtpFromNameKey] ?? 'Family Helper';
    if (_isBlank(host) ||
        _isBlank(username) ||
        _isBlank(password) ||
        _isBlank(fromEmail)) {
      return null;
    }

    final port = int.tryParse(passwords[_smtpPortKey] ?? '') ?? 587;
    final useSsl = _isTruthy(passwords[_smtpUseSslKey]);
    final allowInsecure = _isTruthy(passwords[_smtpAllowInsecureKey]);
    return SmtpEmailCodeSender(
      host: host!,
      port: port,
      username: username!,
      password: password!,
      fromEmail: fromEmail!,
      fromName: fromName,
      useSsl: useSsl,
      allowInsecure: allowInsecure,
    );
  }

  bool _isBlank(String? value) => value == null || value.trim().isEmpty;

  bool _isTruthy(String? value) {
    if (value == null) return false;
    return value.trim().toLowerCase() == 'true';
  }
}
