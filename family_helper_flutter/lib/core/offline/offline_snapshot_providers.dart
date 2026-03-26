import 'package:flutter/foundation.dart';

import '../logging/app_error_logger.dart';
import 'in_memory_offline_snapshot_store.dart';
import 'offline_snapshot_store.dart';
import 'sqlite_offline_snapshot_store.dart';

Future<OfflineSnapshotStore> createOfflineSnapshotStore() async {
  final shouldUsePersistentStore =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  if (!shouldUsePersistentStore) {
    final store = InMemoryOfflineSnapshotStore();
    await store.init();
    return store;
  }

  try {
    final store = SqliteOfflineSnapshotStore();
    await store.init();
    return store;
  } catch (error, stackTrace) {
    AppErrorLogger.logHandled(
      scope: 'offlineSnapshotStore.init',
      error: error,
      stackTrace: stackTrace,
    );
    final fallback = InMemoryOfflineSnapshotStore();
    await fallback.init();
    return fallback;
  }
}
