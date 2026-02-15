import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'offline_operation.dart';
import 'offline_operation_queue.dart';

class SqliteOfflineOperationQueue implements OfflineOperationQueue {
  Database? _db;

  @override
  Future<void> init() async {
    if (_db != null) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'offline_queue.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE offline_operation (
            id TEXT PRIMARY KEY,
            feature TEXT NOT NULL,
            action TEXT NOT NULL,
            payload_json TEXT NOT NULL,
            created_at TEXT NOT NULL,
            attempt INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  @override
  Future<void> enqueue(OfflineOperation operation) async {
    final db = _requireDb();
    await db.insert(
      'offline_operation',
      {
        'id': operation.id,
        'feature': operation.feature,
        'action': operation.action,
        'payload_json': operation.payloadJson(),
        'created_at': operation.createdAt.toUtc().toIso8601String(),
        'attempt': operation.attempt,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<OfflineOperation>> listPending({int limit = 100}) async {
    final db = _requireDb();
    final rows = await db.query(
      'offline_operation',
      orderBy: 'created_at ASC',
      limit: limit,
    );

    return rows
        .map(
          (row) => OfflineOperation(
            id: row['id'] as String,
            feature: row['feature'] as String,
            action: row['action'] as String,
            payload: jsonDecode(row['payload_json'] as String)
                as Map<String, dynamic>,
            createdAt: DateTime.parse(row['created_at'] as String).toUtc(),
            attempt: row['attempt'] as int,
          ),
        )
        .toList();
  }

  @override
  Future<void> markProcessed(String id) async {
    final db = _requireDb();
    await db.delete('offline_operation', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> incrementAttempt(String id) async {
    final db = _requireDb();
    await db.rawUpdate(
      'UPDATE offline_operation SET attempt = attempt + 1 WHERE id = ?',
      [id],
    );
  }

  Database _requireDb() {
    final db = _db;
    if (db == null) {
      throw StateError('Offline queue is not initialized. Call init() first.');
    }
    return db;
  }
}
