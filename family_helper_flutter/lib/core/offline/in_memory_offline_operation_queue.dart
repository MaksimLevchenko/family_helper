import 'offline_operation.dart';
import 'offline_operation_queue.dart';

class InMemoryOfflineOperationQueue implements OfflineOperationQueue {
  final List<OfflineOperation> _operations = <OfflineOperation>[];

  @override
  Future<void> init() async {}

  @override
  Future<void> enqueue(OfflineOperation operation) async {
    if (_operations.any((item) => item.id == operation.id)) {
      return;
    }
    _operations.add(operation);
    _operations.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<List<OfflineOperation>> listPending({int limit = 100}) async {
    return _operations.take(limit).toList(growable: false);
  }

  @override
  Future<void> markProcessed(String id) async {
    _operations.removeWhere((operation) => operation.id == id);
  }

  @override
  Future<void> incrementAttempt(String id) async {
    final index = _operations.indexWhere((operation) => operation.id == id);
    if (index == -1) {
      return;
    }
    final operation = _operations[index];
    _operations[index] = operation.copyWith(attempt: operation.attempt + 1);
  }
}
