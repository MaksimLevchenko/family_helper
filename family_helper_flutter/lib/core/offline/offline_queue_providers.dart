import 'offline_queue_manager.dart';
import 'offline_operation_queue.dart';
import 'sqlite_offline_operation_queue.dart';

Future<OfflineOperationQueue> createOfflineOperationQueue() async {
  final queue = SqliteOfflineOperationQueue();
  await queue.init();
  return queue;
}

Future<OfflineQueueManager> createOfflineQueueManager() async {
  final queue = await createOfflineOperationQueue();
  return OfflineQueueManager(queue);
}
