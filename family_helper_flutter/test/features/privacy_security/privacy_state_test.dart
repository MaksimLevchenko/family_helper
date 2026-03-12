import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/features/privacy_security/providers/privacy_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PrivacyState distinguishes active deletion requests', () {
    final active = PrivacyState(
      accountDeletion: AccountDeletionStatusDto(
        id: 1,
        profileId: 1,
        status: 'scheduled',
        scheduledHardDeleteAt: DateTime.utc(2026, 4, 12),
        createdAt: DateTime.utc(2026, 3, 12),
      ),
    );
    final cancelled = PrivacyState(
      accountDeletion: AccountDeletionStatusDto(
        id: 2,
        profileId: 1,
        status: 'cancelled',
        scheduledHardDeleteAt: DateTime.utc(2026, 4, 12),
        createdAt: DateTime.utc(2026, 3, 12),
      ),
    );

    expect(active.hasActiveDeletionRequest, isTrue);
    expect(cancelled.hasActiveDeletionRequest, isFalse);
  });

  test('PrivacyState distinguishes downloadable and expired exports', () {
    final downloadable = PrivacyState(
      lastExportJob: PrivacyExportJobDto(
        id: 1,
        profileId: 1,
        status: 'ready',
        signedUrl: 'https://example.com/export.zip',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        createdAt: DateTime.utc(2026, 3, 12),
      ),
    );
    final expired = PrivacyState(
      lastExportJob: PrivacyExportJobDto(
        id: 2,
        profileId: 1,
        status: 'ready',
        signedUrl: 'https://example.com/export.zip',
        expiresAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
        createdAt: DateTime.utc(2026, 3, 12),
      ),
    );

    expect(downloadable.canDownloadExport, isTrue);
    expect(expired.isExportExpired, isTrue);
    expect(expired.canDownloadExport, isFalse);
  });
}
