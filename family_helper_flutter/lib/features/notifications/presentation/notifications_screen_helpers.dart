part of 'notifications_screen.dart';

String _timestampLabel(BuildContext context, DateTime createdAt) {
  final localizations = MaterialLocalizations.of(context);
  final local = createdAt.toLocal();
  final date = localizations.formatShortDate(local);
  final time = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: true,
  );
  return '$date, $time';
}

String _categoryLabel(String category) {
  return switch (category) {
    'due_reminder' => 'Reminder',
    'task_assigned' => 'Assigned task',
    'task_completed' => 'Completed task',
    'calendar_created' => 'Calendar update',
    'calendar_updated' => 'Calendar update',
    'calendar_cancelled' => 'Calendar cancelled',
    'family_invite_created' => 'Family invite',
    'family_invite_accepted' => 'Family update',
    'debug_test_push' => 'Test push',
    _ => 'Notification',
  };
}

String _detailActionLabel(NotificationOpenTarget target) {
  return switch (target.entityType) {
    'task' => 'Open task',
    'calendar' => 'Open calendar',
    'list' => 'Open list',
    'goal' => 'Open goal',
    _ => 'Open notification',
  };
}

(IconData, Color, Color, Color) _toneFor(
  BuildContext context,
  AppNotificationDto notification,
) {
  final scheme = Theme.of(context).colorScheme;
  return switch (notification.category) {
    'due_reminder' => (
      Icons.alarm_rounded,
      scheme.primaryContainer,
      scheme.onPrimaryContainer,
      scheme.primary,
    ),
    'task_assigned' || 'task_completed' => (
      Icons.task_alt_rounded,
      scheme.secondaryContainer,
      scheme.onSecondaryContainer,
      scheme.onSecondaryContainer,
    ),
    'calendar_created' || 'calendar_updated' || 'calendar_cancelled' => (
      Icons.event_rounded,
      scheme.tertiaryContainer,
      scheme.onTertiaryContainer,
      scheme.onTertiaryContainer,
    ),
    'family_invite_created' || 'family_invite_accepted' => (
      Icons.groups_2_rounded,
      scheme.primaryContainer,
      scheme.onPrimaryContainer,
      scheme.onPrimaryContainer,
    ),
    'debug_test_push' => (
      Icons.bug_report_rounded,
      scheme.errorContainer,
      scheme.onErrorContainer,
      scheme.onErrorContainer,
    ),
    _ => (
      switch (notification.entityType) {
        'task' => Icons.check_circle_outline_rounded,
        'calendar' => Icons.calendar_today_rounded,
        'goal' => Icons.savings_rounded,
        'list' => Icons.list_alt_rounded,
        _ => Icons.notifications_rounded,
      },
      scheme.surfaceContainerHighest,
      scheme.onSurface,
      scheme.primary,
    ),
  };
}
