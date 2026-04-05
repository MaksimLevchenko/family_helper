class NotificationMessage {
  const NotificationMessage({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

String normalizeNotificationLocaleCode(String? localeCode) {
  final normalized = (localeCode ?? '').trim().toLowerCase();
  if (normalized.startsWith('ru')) {
    return 'ru';
  }
  return 'en';
}

NotificationMessage buildTaskAssignedNotificationMessage({
  required String localeCode,
  required String taskTitle,
}) {
  return switch (normalizeNotificationLocaleCode(localeCode)) {
    'ru' => NotificationMessage(
      title: 'Назначена задача',
      body: taskTitle,
    ),
    _ => NotificationMessage(
      title: 'Task assigned',
      body: taskTitle,
    ),
  };
}

NotificationMessage buildTaskCompletedNotificationMessage({
  required String localeCode,
  required String taskTitle,
}) {
  return switch (normalizeNotificationLocaleCode(localeCode)) {
    'ru' => NotificationMessage(
      title: 'Задача выполнена',
      body: taskTitle,
    ),
    _ => NotificationMessage(
      title: 'Task completed',
      body: taskTitle,
    ),
  };
}

NotificationMessage buildFamilyInviteCreatedNotificationMessage({
  required String localeCode,
  String? email,
}) {
  final normalizedLocale = normalizeNotificationLocaleCode(localeCode);
  final normalizedEmail = email?.trim();
  if (normalizedLocale == 'ru') {
    return NotificationMessage(
      title: 'Приглашение в семью создано',
      body: normalizedEmail != null && normalizedEmail.isNotEmpty
          ? 'Приглашение для $normalizedEmail готово.'
          : 'Новое приглашение в семью готово к отправке.',
    );
  }

  return NotificationMessage(
    title: 'Family invite created',
    body: normalizedEmail != null && normalizedEmail.isNotEmpty
        ? 'Invite ready for $normalizedEmail.'
        : 'A new family invite is ready to share.',
  );
}

NotificationMessage buildFamilyInviteAcceptedNotificationMessage({
  required String localeCode,
  required String displayName,
}) {
  return switch (normalizeNotificationLocaleCode(localeCode)) {
    'ru' => NotificationMessage(
      title: 'Новый участник семьи',
      body: displayName,
    ),
    _ => NotificationMessage(
      title: 'Family member joined',
      body: displayName,
    ),
  };
}

NotificationMessage buildCalendarEventNotificationMessage({
  required String localeCode,
  required String category,
  required String eventTitle,
}) {
  final normalizedLocale = normalizeNotificationLocaleCode(localeCode);
  final title = switch ((normalizedLocale, category)) {
    ('ru', 'calendar_created') => 'Событие календаря создано',
    ('ru', 'calendar_updated') => 'Событие календаря обновлено',
    ('ru', 'calendar_cancelled') => 'Событие календаря отменено',
    (_, 'calendar_created') => 'Calendar event created',
    (_, 'calendar_updated') => 'Calendar event updated',
    (_, 'calendar_cancelled') => 'Calendar event cancelled',
    ('ru', _) => 'Календарь обновлён',
    (_, _) => 'Calendar updated',
  };

  return NotificationMessage(title: title, body: eventTitle);
}

NotificationMessage buildDebugTestPushNotificationMessage({
  required String localeCode,
}) {
  return switch (normalizeNotificationLocaleCode(localeCode)) {
    'ru' => const NotificationMessage(
      title: 'Тестовый push',
      body: 'Если вы видите это сообщение, доставка push через Firebase работает.',
    ),
    _ => const NotificationMessage(
      title: 'Test push',
      body: 'If you see this, Firebase push delivery is working.',
    ),
  };
}

String buildReminderDefaultTitle({
  required String localeCode,
  required String entityType,
}) {
  final normalizedLocale = normalizeNotificationLocaleCode(localeCode);
  return switch ((normalizedLocale, entityType)) {
    ('ru', 'task') => 'Напоминание о задаче',
    ('ru', 'calendar') => 'Напоминание о событии',
    ('ru', 'goal') => 'Напоминание о цели',
    ('ru', 'list') => 'Напоминание о списке',
    ('ru', 'invite') => 'Напоминание о приглашении',
    (_, 'task') => 'Task reminder',
    (_, 'calendar') => 'Event reminder',
    (_, 'goal') => 'Goal reminder',
    (_, 'list') => 'List reminder',
    (_, 'invite') => 'Invite reminder',
    ('ru', _) => 'Напоминание',
    (_, _) => 'Reminder',
  };
}

String buildReminderDefaultFallbackBody(String localeCode) {
  return switch (normalizeNotificationLocaleCode(localeCode)) {
    'ru' => 'Откройте Family Helper, чтобы посмотреть напоминание.',
    _ => 'Open Family Helper to view the reminder.',
  };
}
