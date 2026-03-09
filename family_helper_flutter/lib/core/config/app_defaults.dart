class AppDefaults {
  const AppDefaults._();

  static const apiUrlAssetPath = 'assets/config.json';

  static const defaultTimezone = 'UTC';
  static const defaultCurrency = 'RUB';
  static const defaultListType = 'shopping';
  static const defaultNotificationType = 'task';
  static const defaultReminderEntityType = 'task';
  static const defaultTaskPriority = 'normal';
  static const defaultTaskRecurrenceMode = 'generateOnComplete';
  static const dailyRecurrenceRrule = 'FREQ=DAILY;INTERVAL=1';

  static const calendarLookBehind = Duration(days: 7);
  static const calendarLookAhead = Duration(days: 30);
  static const realtimeDebounce = Duration(milliseconds: 300);
}
