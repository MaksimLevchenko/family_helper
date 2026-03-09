import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../clock/clock_service.dart';
import '../../generated/protocol.dart';

class AuditService {
  const AuditService({this.clock = const ClockService()});

  final ClockService clock;

  Future<void> append(
    Session session, {
    required int? familyId,
    required int actorProfileId,
    required String action,
    required Map<String, dynamic> payload,
    Transaction? transaction,
  }) async {
    await AuditLogRow.db.insertRow(
      session,
      AuditLogRow(
        familyId: familyId,
        actorProfileId: actorProfileId,
        action: action,
        payloadJson: jsonEncode(payload),
        createdAt: clock.nowUtc(),
      ),
      transaction: transaction,
    );
  }
}
