import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'offline_snapshot_store.dart';

class SqliteOfflineSnapshotStore implements OfflineSnapshotStore {
  Database? _db;

  @override
  Future<void> init() async {
    if (_db != null) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'offline_snapshot.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE offline_snapshot (
            cache_key TEXT PRIMARY KEY,
            payload_json TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<OfflineSnapshot?> read(String key) async {
    final db = _requireDb();
    final rows = await db.query(
      'offline_snapshot',
      where: 'cache_key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }

    final row = rows.first;
    return OfflineSnapshot(
      payload: jsonDecode(row['payload_json'] as String) as Map<String, dynamic>,
      updatedAt: DateTime.parse(row['updated_at'] as String).toUtc(),
    );
  }

  @override
  Future<void> write(
    String key,
    Map<String, dynamic> payload, {
    DateTime? updatedAt,
  }) async {
    final db = _requireDb();
    await db.insert(
      'offline_snapshot',
      {
        'cache_key': key,
        'payload_json': jsonEncode(payload),
        'updated_at':
            (updatedAt ?? DateTime.now().toUtc()).toUtc().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> delete(String key) async {
    final db = _requireDb();
    await db.delete(
      'offline_snapshot',
      where: 'cache_key = ?',
      whereArgs: [key],
    );
  }

  @override
  Future<void> deleteByPrefix(String prefix) async {
    final db = _requireDb();
    await db.delete(
      'offline_snapshot',
      where: 'cache_key LIKE ?',
      whereArgs: ['$prefix%'],
    );
  }

  @override
  Future<void> clear() async {
    final db = _requireDb();
    await db.delete('offline_snapshot');
  }

  @override
  Future<void> close() async {
    final db = _db;
    _db = null;
    await db?.close();
  }

  Database _requireDb() {
    final db = _db;
    if (db == null) {
      throw StateError(
        'Offline snapshot store is not initialized. Call init() first.',
      );
    }
    return db;
  }
}
