import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

import '../../auth/email_code_dispatcher.dart';

abstract interface class FamilyInviteEmailSender {
  Future<void> sendInvite({
    required String recipientEmail,
    required String familyTitle,
    required String inviteCode,
    required DateTime expiresAt,
  });
}

String buildFamilyInviteEmailSubject({required String familyTitle}) {
  return 'Invitation to join $familyTitle';
}

String buildFamilyInviteEmailText({
  required String recipientEmail,
  required String familyTitle,
  required String inviteCode,
  required DateTime expiresAt,
}) {
  final expiresAtUtc = expiresAt.toUtc().toIso8601String();
  return '''
You were invited to join "$familyTitle" in Family Helper.

Invite code: $inviteCode

This invite can only be accepted by the account registered with:
$recipientEmail

Open Family Helper, sign in to that account, and enter the invite code on the family join screen.

This invite expires at $expiresAtUtc UTC.
''';
}

class SmtpFamilyInviteEmailSender implements FamilyInviteEmailSender {
  SmtpFamilyInviteEmailSender({required this.settings});

  final SmtpEmailSettings settings;

  @override
  Future<void> sendInvite({
    required String recipientEmail,
    required String familyTitle,
    required String inviteCode,
    required DateTime expiresAt,
  }) async {
    final server = SmtpServer(
      settings.host,
      port: settings.port,
      username: settings.username,
      password: settings.password,
      ssl: settings.useSsl,
      allowInsecure: settings.allowInsecure,
    );

    final message = mailer.Message()
      ..from = mailer.Address(settings.fromEmail, settings.fromName)
      ..recipients.add(recipientEmail)
      ..subject = buildFamilyInviteEmailSubject(familyTitle: familyTitle)
      ..text = buildFamilyInviteEmailText(
        recipientEmail: recipientEmail,
        familyTitle: familyTitle,
        inviteCode: inviteCode,
        expiresAt: expiresAt,
      );

    await mailer.send(message, server);
  }
}

final class FamilyInviteEmailDispatcher {
  const FamilyInviteEmailDispatcher({this.sender});

  static FamilyInviteEmailDispatcher instance =
      const FamilyInviteEmailDispatcher();

  final FamilyInviteEmailSender? sender;

  Future<void> sendInvite(
    Session session, {
    required String recipientEmail,
    required String familyTitle,
    required String inviteCode,
    required DateTime expiresAt,
  }) async {
    final maskedRecipientEmail = _maskEmailForLog(recipientEmail);
    final configuredSender = sender ?? _buildSmtpSender(session);
    if (configuredSender == null) {
      if (session.server.serverpod.runMode == ServerpodRunMode.test &&
          sender == null) {
        session.log(
          '[FamilyInvite] Invite email was not sent to $maskedRecipientEmail because SMTP is not configured in test mode.',
        );
        return;
      }

      session.log(
        '[FamilyInvite] Invite email was not sent to $maskedRecipientEmail because SMTP is not configured.',
        level: LogLevel.error,
      );
      throw StateError('SMTP is not configured for family invite emails.');
    }

    try {
      await configuredSender.sendInvite(
        recipientEmail: recipientEmail,
        familyTitle: familyTitle,
        inviteCode: inviteCode,
        expiresAt: expiresAt,
      );
      session.log(
        '[FamilyInvite] Invite email sent to $maskedRecipientEmail.',
      );
    } catch (error, stackTrace) {
      session.log(
        '[FamilyInvite] Failed to send invite email to $maskedRecipientEmail.',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  SmtpFamilyInviteEmailSender? _buildSmtpSender(Session session) {
    final settings = resolveSmtpEmailSettings(session.passwords);
    if (settings == null) {
      return null;
    }

    return SmtpFamilyInviteEmailSender(settings: settings);
  }
}

String _maskEmailForLog(String email) {
  final normalizedEmail = email.trim();
  final atIndex = normalizedEmail.indexOf('@');
  if (atIndex <= 0 || atIndex == normalizedEmail.length - 1) {
    return '***';
  }

  final localPart = normalizedEmail.substring(0, atIndex);
  final domainPart = normalizedEmail.substring(atIndex + 1);
  final maskedLocalPart = localPart.length <= 2
      ? '${localPart[0]}***'
      : '${localPart[0]}***${localPart[localPart.length - 1]}';
  return '$maskedLocalPart@$domainPart';
}
