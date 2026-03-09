// ignore_for_file: implementation_imports

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/future_call_entry.dart';

import '../core/clock/clock_service.dart';
import 'account_deletion_call.dart';
import 'future_call_names.dart';
import 'media_cleanup_call.dart';
import 'notifications_due_reminder_call.dart';
import 'privacy_export_call.dart';

final class FutureCallRegistry {
  const FutureCallRegistry._();

  static const _clock = ClockService();

  static void registerAll(Serverpod pod) {
    pod.registerFutureCall(
      NotificationsDueReminderCall(),
      FutureCallNames.notificationsDueReminder,
    );
    pod.registerFutureCall(
      MediaCleanupCall(),
      FutureCallNames.mediaCleanup,
    );
    pod.registerFutureCall(
      PrivacyExportCall(),
      FutureCallNames.privacyExport,
    );
    pod.registerFutureCall(
      AccountDeletionCall(),
      FutureCallNames.accountDeletion,
    );
  }

  static Future<void> scheduleAll(Serverpod pod) async {
    await scheduleNotificationsDueReminder(pod);
    await scheduleMediaCleanup(pod);
    await schedulePrivacyExport(pod);
    await scheduleAccountDeletion(pod);
  }

  static Future<void> scheduleNotificationsDueReminder(Serverpod pod) {
    return _scheduleUnique(
      pod,
      callName: FutureCallNames.notificationsDueReminder,
      delay: const Duration(seconds: 30),
      identifier: FutureCallNames.notificationsDueReminderIdentifier,
    );
  }

  static Future<void> scheduleMediaCleanup(Serverpod pod) {
    return _scheduleUnique(
      pod,
      callName: FutureCallNames.mediaCleanup,
      delay: const Duration(minutes: 15),
      identifier: FutureCallNames.mediaCleanupIdentifier,
    );
  }

  static Future<void> schedulePrivacyExport(Serverpod pod) {
    return _scheduleUnique(
      pod,
      callName: FutureCallNames.privacyExport,
      delay: const Duration(minutes: 5),
      identifier: FutureCallNames.privacyExportIdentifier,
    );
  }

  static Future<void> scheduleAccountDeletion(Serverpod pod) {
    return _scheduleUnique(
      pod,
      callName: FutureCallNames.accountDeletion,
      delay: const Duration(hours: 6),
      identifier: FutureCallNames.accountDeletionIdentifier,
    );
  }

  static Future<void> _scheduleUnique(
    Serverpod pod, {
    required String callName,
    required Duration delay,
    required String identifier,
  }) async {
    // Keep exactly one pending job per worker across server restarts.
    final session = await pod.createSession();
    try {
      await FutureCallEntry.db.deleteWhere(
        session,
        where: (t) => t.identifier.equals(identifier),
      );
      await FutureCallEntry.db.insertRow(
        session,
        FutureCallEntry(
          name: callName,
          time: _clock.nowUtc().add(delay),
          serializedObject: null,
          serverId: pod.serverId,
          identifier: identifier,
        ),
      );
    } finally {
      await session.close();
    }
  }
}
