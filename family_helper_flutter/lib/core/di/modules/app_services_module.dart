import 'package:get_it/get_it.dart';

import '../../network/app_api_client.dart';
import '../../offline/offline_queue_manager.dart';
import '../../offline/offline_queue_providers.dart';
import '../../offline/offline_snapshot_providers.dart';
import '../../offline/offline_snapshot_store.dart';
import '../../realtime/realtime_subscription_manager.dart';
import '../../../features/notifications/data/local_notification_service.dart';

Future<void> registerAppServices(GetIt getIt) async {
  final apiClient = await AppApiClient.create();
  final offlineQueueManager = await createOfflineQueueManager();
  final offlineSnapshotStore = await createOfflineSnapshotStore();

  getIt.registerSingleton<AppApiClient>(apiClient);
  getIt.registerSingleton<OfflineQueueManager>(offlineQueueManager);
  getIt.registerSingleton<OfflineSnapshotStore>(
    offlineSnapshotStore,
    dispose: (store) => store.close(),
  );

  getIt.registerLazySingleton<RealtimeSubscriptionDriver>(
    () => RealtimeSubscriptionManager(getIt()),
  );
  getIt.registerLazySingleton<LocalNotificationService>(
    LocalNotificationService.new,
  );
}
