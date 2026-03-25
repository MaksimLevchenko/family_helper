import 'dart:collection';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/offline/offline_operation.dart';
import 'package:family_helper_flutter/core/offline/offline_operation_queue.dart';
import 'package:family_helper_flutter/core/offline/offline_queue_manager.dart';
import 'package:family_helper_flutter/features/privacy_security/data/privacy_repository.dart';
import 'package:family_helper_flutter/features/privacy_security/providers/privacy_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePrivacyRepository implements PrivacyRepositoryContract {
  _FakePrivacyRepository({
    required this.requestExportResult,
    required List<PrivacyStatusDto> statusResponses,
  }) : _statusResponses = Queue<PrivacyStatusDto>.from(statusResponses),
       _lastStatus = statusResponses.isEmpty ? null : statusResponses.last;

  final PrivacyExportJobDto requestExportResult;
  final Queue<PrivacyStatusDto> _statusResponses;
  final PrivacyStatusDto? _lastStatus;
  int getStatusCalls = 0;

  @override
  Future<AccountDeletionStatusDto> cancelAccountDeletion() {
    throw UnimplementedError();
  }

  @override
  Future<PrivacyStatusDto> getStatus() async {
    getStatusCalls += 1;
    if (_statusResponses.isNotEmpty) {
      return _statusResponses.removeFirst();
    }
    return _lastStatus ?? PrivacyStatusDto(lastExportJob: requestExportResult);
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
    return requestExportResult;
  }
}

class _InMemoryOfflineOperationQueue implements OfflineOperationQueue {
  final Map<String, OfflineOperation> _operations = {};

  @override
  Future<void> enqueue(OfflineOperation operation) async {
    _operations[operation.id] = operation;
  }

  @override
  Future<void> incrementAttempt(String id) async {
    final operation = _operations[id];
    if (operation == null) {
      return;
    }
    _operations[id] = operation.copyWith(attempt: operation.attempt + 1);
  }

  @override
  Future<void> init() async {}

  @override
  Future<List<OfflineOperation>> listPending({int limit = 100}) async {
    return _operations.values.take(limit).toList();
  }

  @override
  Future<void> markProcessed(String id) async {
    _operations.remove(id);
  }
}

void main() {
  Future<void> immediateDelay(Duration _) async {}

  PrivacyExportJobDto buildJob({
    required int id,
    required String status,
    String? signedUrl,
    DateTime? expiresAt,
    DateTime? completedAt,
  }) {
    return PrivacyExportJobDto(
      id: id,
      profileId: 1,
      status: status,
      signedUrl: signedUrl,
      expiresAt: expiresAt,
      createdAt: DateTime.utc(2026, 3, 25),
      completedAt: completedAt,
    );
  }

  OfflineQueueManager buildOfflineQueueManager() {
    return OfflineQueueManager(_InMemoryOfflineOperationQueue());
  }

  test('requestExport polls until export becomes ready', () async {
    final readyAt = DateTime.now().toUtc().add(const Duration(hours: 1));
    final pendingJob = buildJob(id: 1, status: 'pending');
    final readyJob = buildJob(
      id: 1,
      status: 'ready',
      signedUrl: 'https://example.com/export.json',
      expiresAt: readyAt,
      completedAt: DateTime.now().toUtc(),
    );
    final repository = _FakePrivacyRepository(
      requestExportResult: pendingJob,
      statusResponses: [
        PrivacyStatusDto(lastExportJob: pendingJob),
        PrivacyStatusDto(lastExportJob: readyJob),
      ],
    );
    final cubit = PrivacyCubit(
      repository: repository,
      offlineQueueManager: buildOfflineQueueManager(),
      exportStatusPollInterval: Duration.zero,
      exportStatusPollingTimeout: const Duration(seconds: 1),
      delay: immediateDelay,
    );

    await cubit.requestExport();
    await pumpEventQueue(times: 20);

    expect(cubit.state.lastExportJob?.status, 'ready');
    expect(cubit.state.canDownloadExport, isTrue);
    expect(repository.getStatusCalls, 2);

    await cubit.close();
  });

  test('requestExport polling stops when export becomes failed', () async {
    final pendingJob = buildJob(id: 7, status: 'pending');
    final failedJob = buildJob(
      id: 7,
      status: 'failed',
      completedAt: DateTime.now().toUtc(),
    );
    final repository = _FakePrivacyRepository(
      requestExportResult: pendingJob,
      statusResponses: [
        PrivacyStatusDto(lastExportJob: pendingJob),
        PrivacyStatusDto(lastExportJob: failedJob),
        PrivacyStatusDto(
          lastExportJob: buildJob(
            id: 7,
            status: 'ready',
            signedUrl: 'https://example.com/should-not-be-read.json',
            expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
        ),
      ],
    );
    final cubit = PrivacyCubit(
      repository: repository,
      offlineQueueManager: buildOfflineQueueManager(),
      exportStatusPollInterval: Duration.zero,
      exportStatusPollingTimeout: const Duration(seconds: 1),
      delay: immediateDelay,
    );

    await cubit.requestExport();
    await pumpEventQueue(times: 20);

    expect(cubit.state.lastExportJob?.status, 'failed');
    expect(cubit.state.canDownloadExport, isFalse);
    expect(repository.getStatusCalls, 2);

    await cubit.close();
  });
}
