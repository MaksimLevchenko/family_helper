import 'dart:async';

import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

enum EmailCodeKind { registration, passwordReset }

const _smtpProviderKey = 'smtpProvider';
const _smtpHostKey = 'smtpHost';
const _smtpPortKey = 'smtpPort';
const _smtpUsernameKey = 'smtpUsername';
const _smtpPasswordKey = 'smtpPassword';
const _smtpFromEmailKey = 'smtpFromEmail';
const _smtpFromNameKey = 'smtpFromName';
const _smtpUseSslKey = 'smtpUseSsl';
const _smtpAllowInsecureKey = 'smtpAllowInsecure';
const _defaultFromName = 'Family Helper';
const _yandexProvider = 'yandex';
const _yandexHost = 'smtp.yandex.com';

abstract interface class EmailCodeSender {
  Future<void> sendCode({
    required String recipientEmail,
    required String verificationCode,
    required EmailCodeKind kind,
  });
}

class SmtpEmailSettings {
  const SmtpEmailSettings({
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
}

SmtpEmailSettings? resolveSmtpEmailSettings(Map<String, String> passwords) {
  final provider = passwords[_smtpProviderKey]?.trim().toLowerCase();
  final username = passwords[_smtpUsernameKey];
  final password = passwords[_smtpPasswordKey];
  final fromEmail = passwords[_smtpFromEmailKey];
  final fromName = passwords[_smtpFromNameKey] ?? _defaultFromName;

  final defaultHost = provider == _yandexProvider ? _yandexHost : null;
  final defaultPort = provider == _yandexProvider ? 465 : 587;
  final defaultUseSsl = provider == _yandexProvider;

  final host = passwords[_smtpHostKey] ?? defaultHost;
  if (_isBlank(host) ||
      _isBlank(username) ||
      _isBlank(password) ||
      _isBlank(fromEmail)) {
    return null;
  }

  final port = int.tryParse(passwords[_smtpPortKey] ?? '') ?? defaultPort;
  final useSslValue = passwords[_smtpUseSslKey];
  final useSsl = _isBlank(useSslValue) ? defaultUseSsl : _isTruthy(useSslValue);
  final allowInsecure = _isTruthy(passwords[_smtpAllowInsecureKey]);

  return SmtpEmailSettings(
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

class SmtpEmailCodeSender implements EmailCodeSender {
  SmtpEmailCodeSender({required SmtpEmailSettings settings})
    : host = settings.host,
      port = settings.port,
      username = settings.username,
      password = settings.password,
      fromEmail = settings.fromEmail,
      fromName = settings.fromName,
      useSsl = settings.useSsl,
      allowInsecure = settings.allowInsecure;

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
    if (shouldDisplayEmailCodeForRunMode(
      runMode: runMode,
      hasSender: smtpSender != null,
      hasInjectedSender: injectedSender != null,
    )) {
      session.log(
        '[EmailIdp] ${kind.name} code for $email: $verificationCode',
      );
    }

    if (smtpSender == null ||
        (runMode == ServerpodRunMode.test && injectedSender == null)) {
      // Dev/test fallback when SMTP is not configured.
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
    final settings = resolveSmtpEmailSettings(session.passwords);
    if (settings == null) {
      return null;
    }

    return SmtpEmailCodeSender(settings: settings);
  }
}

bool shouldDisplayEmailCodeForRunMode({
  required String runMode,
  required bool hasSender,
  required bool hasInjectedSender,
}) {
  return runMode == ServerpodRunMode.development ||
      !hasSender ||
      (runMode == ServerpodRunMode.test && !hasInjectedSender);
}

bool _isBlank(String? value) => value == null || value.trim().isEmpty;

bool _isTruthy(String? value) {
  if (value == null) return false;
  return value.trim().toLowerCase() == 'true';
}
