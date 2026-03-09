import 'package:get_it/get_it.dart';

import '../../network/app_api_client.dart';
import '../../realtime/realtime_subscription_manager.dart';
import '../../../features/notifications/data/local_notification_service.dart';

Future<void> registerAppServices(GetIt getIt) async {
  final apiClient = await AppApiClient.create();

  getIt.registerSingleton<AppApiClient>(apiClient);

  getIt.registerLazySingleton<RealtimeSubscriptionManager>(
    () => RealtimeSubscriptionManager(getIt()),
  );
  getIt.registerLazySingleton<LocalNotificationService>(
    LocalNotificationService.new,
  );
}
