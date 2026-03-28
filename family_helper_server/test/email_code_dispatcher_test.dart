import 'package:family_helper_server/src/auth/email_code_dispatcher.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('resolveSmtpEmailSettings', () {
    test('uses Yandex defaults when provider is yandex', () {
      final settings = resolveSmtpEmailSettings({
        'smtpProvider': 'yandex',
        'smtpUsername': 'robot@yandex.ru',
        'smtpPassword': 'secret',
        'smtpFromEmail': 'robot@yandex.ru',
      });

      expect(settings, isNotNull);
      expect(settings!.host, 'smtp.yandex.com');
      expect(settings.port, 465);
      expect(settings.useSsl, isTrue);
      expect(settings.allowInsecure, isFalse);
      expect(settings.fromName, 'Family Helper');
    });

    test('allows overriding Yandex defaults explicitly', () {
      final settings = resolveSmtpEmailSettings({
        'smtpProvider': 'yandex',
        'smtpHost': 'smtp.custom.local',
        'smtpPort': '587',
        'smtpUsername': 'robot@yandex.ru',
        'smtpPassword': 'secret',
        'smtpFromEmail': 'robot@yandex.ru',
        'smtpUseSsl': 'false',
        'smtpAllowInsecure': 'true',
        'smtpFromName': 'Mailer',
      });

      expect(settings, isNotNull);
      expect(settings!.host, 'smtp.custom.local');
      expect(settings.port, 587);
      expect(settings.useSsl, isFalse);
      expect(settings.allowInsecure, isTrue);
      expect(settings.fromName, 'Mailer');
    });

    test('returns null when required secrets are missing', () {
      final settings = resolveSmtpEmailSettings({
        'smtpProvider': 'yandex',
        'smtpUsername': 'robot@yandex.ru',
      });

      expect(settings, isNull);
    });
  });

  group('shouldDisplayEmailCodeForRunMode', () {
    test('returns true in development even when sender is configured', () {
      final shouldDisplay = shouldDisplayEmailCodeForRunMode(
        runMode: ServerpodRunMode.development,
        hasSender: true,
        hasInjectedSender: false,
      );

      expect(shouldDisplay, isTrue);
    });

    test('returns false in production when sender is configured', () {
      final shouldDisplay = shouldDisplayEmailCodeForRunMode(
        runMode: ServerpodRunMode.production,
        hasSender: true,
        hasInjectedSender: false,
      );

      expect(shouldDisplay, isFalse);
    });

    test('returns true in test without injected sender', () {
      final shouldDisplay = shouldDisplayEmailCodeForRunMode(
        runMode: ServerpodRunMode.test,
        hasSender: true,
        hasInjectedSender: false,
      );

      expect(shouldDisplay, isTrue);
    });
  });
}
