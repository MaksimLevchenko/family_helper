import 'package:family_helper_server/src/family/services/family_invite_email_dispatcher.dart';
import 'package:test/test.dart';

void main() {
  group('family invite email content', () {
    test('builds a readable subject and body', () {
      final subject = buildFamilyInviteEmailSubject(
        familyTitle: 'Home Team',
      );
      final body = buildFamilyInviteEmailText(
        recipientEmail: 'guest@example.com',
        familyTitle: 'Home Team',
        inviteCode: 'ABCD1234',
        expiresAt: DateTime.utc(2026, 3, 28, 12, 30),
      );

      expect(subject, 'Invitation to join Home Team');
      expect(body, contains('Invite code: ABCD1234'));
      expect(body, contains('guest@example.com'));
      expect(body, contains('Home Team'));
      expect(body, contains('2026-03-28T12:30:00.000Z'));
    });
  });
}
