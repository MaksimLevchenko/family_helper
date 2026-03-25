import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/offline/offline_operation.dart';
import 'package:family_helper_flutter/core/offline/offline_operation_queue.dart';
import 'package:family_helper_flutter/core/offline/offline_queue_manager.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/auth_profile/data/profile_repository.dart';
import 'package:family_helper_flutter/features/auth_profile/providers/profile_provider.dart';
import 'package:family_helper_flutter/features/privacy_security/data/privacy_repository.dart';
import 'package:family_helper_flutter/features/privacy_security/presentation/privacy_security_screen.dart';
import 'package:family_helper_flutter/features/privacy_security/providers/privacy_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePrivacyRepository implements PrivacyRepositoryContract {
  _FakePrivacyRepository(this.status);

  final PrivacyStatusDto status;

  @override
  Future<AccountDeletionStatusDto> cancelAccountDeletion() {
    throw UnimplementedError();
  }

  @override
  Future<PrivacyStatusDto> getStatus() async {
    return status;
  }

  @override
  Future<AccountDeletionStatusDto> requestAccountDeletion({
    required String clientOperationId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PrivacyExportJobDto> requestExport({
    required String clientOperationId,
  }) async {
    return status.lastExportJob!;
  }
}

class _FakeProfileRepository implements ProfileRepositoryContract {
  @override
  Future<ProfileDto> me() async {
    return ProfileDto(
      id: 1,
      authUserId: '00000000-0000-4000-8000-000000000001',
      displayName: 'Test User',
      timezone: 'UTC',
      analyticsOptIn: false,
      createdAt: DateTime.utc(2026, 3, 25),
      updatedAt: DateTime.utc(2026, 3, 25),
    );
  }

  @override
  Future<ProfileDto> update({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool clearAvatarMedia = false,
    bool? analyticsOptIn,
  }) async {
    return me();
  }
}

class _InMemoryOfflineOperationQueue implements OfflineOperationQueue {
  @override
  Future<void> enqueue(OfflineOperation operation) async {}

  @override
  Future<void> incrementAttempt(String id) async {}

  @override
  Future<void> init() async {}

  @override
  Future<List<OfflineOperation>> listPending({int limit = 100}) async {
    return const [];
  }

  @override
  Future<void> markProcessed(String id) async {}
}

Widget buildSubject(PrivacyStatusDto status) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<PrivacyCubit>(
        create: (_) => PrivacyCubit(
          repository: _FakePrivacyRepository(status),
          offlineQueueManager: OfflineQueueManager(
            _InMemoryOfflineOperationQueue(),
          ),
          exportStatusPollInterval: Duration.zero,
          exportStatusPollingTimeout: const Duration(seconds: 1),
          delay: (_) async {},
        ),
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(repository: _FakeProfileRepository()),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const PrivacySecurityScreen(),
    ),
  );
}

void main() {
  PrivacyExportJobDto buildJob({
    required String status,
    String? signedUrl,
    DateTime? expiresAt,
  }) {
    return PrivacyExportJobDto(
      id: 1,
      profileId: 1,
      status: status,
      signedUrl: signedUrl,
      expiresAt: expiresAt,
      createdAt: DateTime.utc(2026, 3, 25),
    );
  }

  testWidgets('shows download button when export is ready', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        PrivacyStatusDto(
          lastExportJob: buildJob(
            status: 'ready',
            signedUrl: 'https://example.com/export.json',
            expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Download export'), findsOneWidget);
  });

  testWidgets('hides download button while export is still pending', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        PrivacyStatusDto(lastExportJob: buildJob(status: 'pending')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Download export'), findsNothing);
  });
}
