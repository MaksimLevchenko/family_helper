import 'package:test/test.dart';
import 'package:family_helper_server/src/generated/protocol.dart';
import 'package:family_helper_server/src/privacy/services/privacy_service.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Privacy workers', (sessionBuilder, endpoints) {
    test('export worker creates payload and deletion worker hard-deletes profile', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final job = await endpoints.privacy.requestExport(
        owner,
        clientOperationId: 'privacy-export-001',
      );
      expect(job.status, 'pending');

      final privacyService = PrivacyService();
      final processedExports = await withDbSession(
        owner,
        privacyService.processExportJobs,
      );
      expect(processedExports, 1);

      final exportStatus = await withDbSession(owner, (session) async {
        return PrivacyExportJobRow.db.findById(session, job.id);
      });

      expect(exportStatus!.status, 'ready');
      final signedUrl = exportStatus.signedUrl;
      expect(signedUrl, isNotNull);
      expect(signedUrl!.startsWith('data:application/json;'), isTrue);

      final deletion = await endpoints.privacy.requestAccountDeletion(
        owner,
        clientOperationId: 'privacy-delete-001',
      );
      expect(deletion.status, 'scheduled');

      await withDbSession(owner, (session) async {
        final row = await AccountDeletionRequestRow.db.findFirstRow(
          session,
          where: (t) => t.profileId.equals(deletion.profileId),
        );
        await AccountDeletionRequestRow.db.updateRow(
          session,
          row!.copyWith(
            scheduledHardDeleteAt: DateTime.now()
                .toUtc()
                .subtract(const Duration(minutes: 1)),
          ),
        );
      });

      final processedDeletion = await withDbSession(
        owner,
        privacyService.processHardDeletion,
      );
      expect(processedDeletion, 1);

      final profileDeletedAt = await withDbSession(owner, (session) async {
        final row = await AppProfileRow.db.findById(session, deletion.profileId);
        return row!.deletedAt;
      });
      expect(profileDeletedAt, isNotNull);

      final deletionStatus = await withDbSession(owner, (session) async {
        final row = await AccountDeletionRequestRow.db.findFirstRow(
          session,
          where: (t) => t.profileId.equals(deletion.profileId),
        );
        return row!.status;
      });
      expect(deletionStatus, 'hard_deleted');
    });
  });
}


