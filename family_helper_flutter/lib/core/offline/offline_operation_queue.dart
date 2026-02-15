import 'offline_operation.dart';

abstract class OfflineOperationQueue {
  Future<void> init();

  Future<void> enqueue(OfflineOperation operation);

  Future<List<OfflineOperation>> listPending({int limit = 100});

  Future<void> markProcessed(String id);

  Future<void> incrementAttempt(String id);
}
