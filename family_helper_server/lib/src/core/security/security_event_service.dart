import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../clock/clock_service.dart';
import '../../generated/protocol.dart';

class SecurityEventService {
  const SecurityEventService({this.clock = const ClockService()});

  final ClockService clock;

  Future<void> append(
    Session session, {
    required String authUserId,
    required String eventType,
    required bool success,
    Map<String, dynamic>? payload,
    Transaction? transaction,
  }) async {
    await SecurityEventRow.db.insertRow(
      session,
      SecurityEventRow(
        authUserId: authUserId,
        eventType: eventType,
        success: success,
        payloadJson: jsonEncode(payload ?? const <String, dynamic>{}),
        createdAt: clock.nowUtc(),
      ),
      transaction: transaction,
    );
  }
}
