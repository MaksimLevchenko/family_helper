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

String _categoryLabel(BuildContext context, String category) {
  final l10n = context.l10n;
  return switch (category) {
    'due_reminder' => l10n.notificationCategoryReminder,
    'task_assigned' => l10n.notificationCategoryTaskAssigned,
    'task_completed' => l10n.notificationCategoryTaskCompleted,
    'calendar_created' => l10n.notificationCategoryCalendarUpdate,
    'calendar_updated' => l10n.notificationCategoryCalendarUpdate,
    'calendar_cancelled' => l10n.notificationCategoryCalendarCancelled,
    'family_invite_created' => l10n.notificationCategoryFamilyInvite,
    'family_invite_accepted' => l10n.notificationCategoryFamilyUpdate,
    'debug_test_push' => l10n.notificationCategoryTestPush,
    _ => l10n.notificationCategoryGeneric,
  };
}

String _detailActionLabel(BuildContext context, NotificationOpenTarget target) {
  final l10n = context.l10n;
  return switch (target.entityType) {
    'task' => l10n.notificationOpenTask,
    'calendar' => l10n.notificationOpenCalendar,
    'list' => l10n.notificationOpenList,
    'goal' => l10n.notificationOpenGoal,
    _ => l10n.notificationOpenNotification,
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
