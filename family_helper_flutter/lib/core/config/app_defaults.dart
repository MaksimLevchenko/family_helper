class AppDefaults {
  const AppDefaults._();

  static const apiUrlAssetPath = 'assets/config.json';

  static const defaultTimezone = 'UTC';
  static const defaultCurrency = 'RUB';
  static const defaultListType = 'shopping';
  static const taskNotificationType = 'task';
  static const calendarNotificationType = 'calendar';
  static const taskReminderEntityType = 'task';
  static const calendarReminderEntityType = 'calendar';
  static const defaultTaskPriority = 'normal';
  static const defaultTaskRecurrenceMode = 'generateOnComplete';
  static const dailyRecurrenceRrule = 'FREQ=DAILY;INTERVAL=1';

  static const calendarLookBehind = Duration(days: 7);
  static const calendarLookAhead = Duration(days: 30);
  static const realtimeDebounce = Duration(milliseconds: 300);
}
