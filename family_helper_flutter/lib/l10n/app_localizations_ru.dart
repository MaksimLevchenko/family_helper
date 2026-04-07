// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Family Helper';

  @override
  String get bootstrapUnableToStart => 'Не удалось запустить приложение.';

  @override
  String get bootstrapPreparingSpace => 'Подготавливаем ваше пространство...';

  @override
  String get notificationActionTooltip => 'Уведомления';

  @override
  String get serverUnavailableBanner =>
      'Сервер недоступен. Некоторые действия могут не работать, пока соединение не восстановится.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAccountSection => 'Аккаунт';

  @override
  String get settingsAppearanceSection => 'Оформление';

  @override
  String get settingsLanguageSection => 'Язык';

  @override
  String get settingsProfileTitle => 'Профиль';

  @override
  String get settingsFamilyTitle => 'Семья';

  @override
  String get settingsNotificationsTitle => 'Уведомления';

  @override
  String get settingsPrivacyTitle => 'Приватность';

  @override
  String get settingsLanguageTitle => 'Язык приложения';

  @override
  String get settingsLanguageSubtitle =>
      'Выберите, как Family Helper определяет язык на этом устройстве и для ваших уведомлений.';

  @override
  String get settingsLanguageSystem => 'Системный';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsThemeTitle => 'Тема';

  @override
  String settingsCurrentMode(String mode) {
    return 'Текущий режим: $mode';
  }

  @override
  String get themeModeSystem => 'Системная';

  @override
  String get themeModeLight => 'Светлая';

  @override
  String get themeModeDark => 'Тёмная';

  @override
  String get settingsSignOut => 'Выйти';

  @override
  String get settingsProfileSummaryLoading => 'Загружаем профиль...';

  @override
  String get settingsProfileSummaryEmpty => 'Обновите имя, часовой пояс и фото';

  @override
  String get settingsPhotoMissing => 'Фото нет';

  @override
  String get settingsPhotoAdded => 'Фото добавлено';

  @override
  String get settingsFamilySummaryNotConnected => 'Не подключено';

  @override
  String get settingsFamilySummaryLoading => 'Загружаем семью...';

  @override
  String get settingsFamilySummaryConnected => 'Семья подключена';

  @override
  String settingsMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участника',
      many: '$count участников',
      few: '$count участника',
      one: '$count участник',
    );
    return '$_temp0';
  }

  @override
  String get settingsSwitchOn => 'Вкл';

  @override
  String get settingsSwitchOff => 'Выкл';

  @override
  String settingsNotificationsSummary(
    String permission,
    String tasks,
    String calendar,
  ) {
    return '$permission • Задачи $tasks • Календарь $calendar';
  }

  @override
  String get settingsAnalyticsOn => 'Аналитика включена';

  @override
  String get settingsAnalyticsOff => 'Аналитика выключена';

  @override
  String get settingsDeletionScheduled => 'Удаление запланировано';

  @override
  String get settingsExportReady => 'Экспорт готов';

  @override
  String get settingsExportExpired => 'Экспорт истёк';

  @override
  String get settingsExportFailed => 'Экспорт не удался';

  @override
  String get settingsPreparingExport => 'Готовим экспорт';

  @override
  String get settingsNoActiveRequests => 'Нет активных запросов';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileNotFoundTitle => 'Профиль не найден';

  @override
  String get profileNotFoundMessage => 'Войдите и обновите профиль.';

  @override
  String get profileDisplayNameLabel => 'Отображаемое имя';

  @override
  String get profileTimezoneLabel => 'Часовой пояс';

  @override
  String get profileSave => 'Сохранить профиль';

  @override
  String get profileNoPhotoYet => 'Фото профиля пока нет';

  @override
  String get profilePhoto => 'Фото профиля';

  @override
  String get profilePhotoHint =>
      'Используйте понятное фото, чтобы члены семьи легко вас узнавали.';

  @override
  String get profileAddPhoto => 'Добавить фото';

  @override
  String get profileChangePhoto => 'Изменить фото';

  @override
  String get profileRemovePhoto => 'Удалить фото';

  @override
  String get homeTitle => 'Главная';

  @override
  String get homeNoFamilyTitle => 'Соберите красивую семейную панель';

  @override
  String get homeNoFamilyMessage =>
      'Создайте или присоединитесь к семье, чтобы собрать общие планы, задачи, списки покупок и финансовые цели в одном тёплом пространстве.';

  @override
  String get homeFeatureSharedCalendar => 'Общий календарь';

  @override
  String get homeFeatureFamilyTasks => 'Семейные задачи';

  @override
  String get homeFeatureListsSync => 'Списки с синхронизацией';

  @override
  String get homeFeatureSavingsGoals => 'Совместные накопления';

  @override
  String get homeAddFamily => 'Добавить семью';

  @override
  String get homeHeroFamilyFallback => 'Ваша семья';

  @override
  String get homeHeroSharedDashboard => 'Общая панель';

  @override
  String get homeHeroTitle => 'Всё, что нужно вашей семье, с первого взгляда.';

  @override
  String get homeHeroSubtitle =>
      'Начните здесь, чтобы увидеть ближайшие события, задачи, которым нужно внимание, и цели, к которым вы движетесь вместе.';

  @override
  String get homeTasks => 'Задачи';

  @override
  String get homeCalendar => 'Календарь';

  @override
  String get homeLists => 'Списки';

  @override
  String get homeGoals => 'Цели';

  @override
  String get homeTasksDescription => 'Открытые задачи, готовые к фокусу';

  @override
  String get homeCalendarDescription =>
      'Запланированные события на семейной линии времени';

  @override
  String get homeListsDescription => 'Пункты, которые ещё ждут отметки';

  @override
  String get homeGoalsDescription => 'Активные цели накоплений';

  @override
  String get homeComingUp => 'Скоро';

  @override
  String get homeComingUpSubtitle =>
      'Ближайшие события, к которым движется вся семья.';

  @override
  String get homeNeedsAttention => 'Требует внимания';

  @override
  String get homeNeedsAttentionSubtitle =>
      'Быстрый обзор задач, которые сейчас важнее всего.';

  @override
  String get homeNoUpcomingEventsTitle => 'Ближайших событий нет';

  @override
  String get homeNoUpcomingEventsMessage =>
      'Следующие семейные планы появятся здесь, как только что-то попадёт в календарь.';

  @override
  String get homeNoUrgentTasksTitle => 'Срочных задач сейчас нет';

  @override
  String get homeNoUrgentTasksMessage =>
      'Когда появятся задачи, требующие внимания, они покажутся здесь в порядке приоритета.';

  @override
  String get homeNotificationEnableTitle =>
      'Не пропускайте семейные напоминания';

  @override
  String get homeNotificationBlockedTitle => 'Уведомления заблокированы';

  @override
  String get homeQuickNavigation => 'Быстрая навигация';

  @override
  String get homeQuickNavigationSubtitle =>
      'Переходите сразу к той части семейного процесса, которую хотите продолжить.';

  @override
  String get homeSavingsSpotlight => 'Фокус на накоплениях';

  @override
  String get homeNoGoalsTitle => 'Активных целей пока нет';

  @override
  String get homeNoGoalsMessage =>
      'Создайте финансовую цель, чтобы следующий семейный рубеж был всегда на виду.';

  @override
  String homeGoalLeft(String amount) {
    return 'Осталось $amount';
  }

  @override
  String homeDeadline(String date) {
    return 'Срок: $date';
  }

  @override
  String get homeOpenGoals => 'Открыть цели';

  @override
  String get homeListsSpotlight => 'Фокус на списках';

  @override
  String get homeNoListsTitle => 'Активных списков нет';

  @override
  String get homeNoListsMessage =>
      'Создайте список покупок или дел, и он станет частью ритма панели здесь.';

  @override
  String homeListItemsOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Открыто $count пункта',
      many: 'Открыто $count пунктов',
      few: 'Открыто $count пункта',
      one: 'Открыт $count пункт',
    );
    return '$_temp0';
  }

  @override
  String get homeListEverythingDone => 'Здесь всё уже завершено.';

  @override
  String get homeListMomentum =>
      'Быстрое место, чтобы продолжить список, в котором сейчас больше всего движения.';

  @override
  String get homeOpenLists => 'Открыть списки';

  @override
  String get homeTaskUrgencyNoDate => 'Без срока';

  @override
  String get homeTaskUrgencyOverdue => 'Просрочено';

  @override
  String get homeTaskUrgencyToday => 'На сегодня';

  @override
  String get homeTaskUrgencyUpcoming => 'Скоро';

  @override
  String get homeTaskDueHint => 'Добавьте срок, чтобы расставить приоритеты';

  @override
  String get listTypeShopping => 'Покупки';

  @override
  String get listTypeTodo => 'Дела';

  @override
  String get notificationsSettingsTitle => 'Настройки уведомлений';

  @override
  String get notificationsTuneTitle =>
      'Настройте, как Family Helper с вами связывается';

  @override
  String get notificationsTuneSubtitle =>
      'Выберите, какие напоминания активны на этом устройстве, и поддерживайте разрешения в рабочем состоянии.';

  @override
  String get notificationsSystemTitle => 'Системные уведомления';

  @override
  String get notificationsEnabled => 'Уведомления включены';

  @override
  String get notificationsDebugTitle => 'Инструменты отладки';

  @override
  String get notificationsDebugSubtitle =>
      'Отправляет реальный Firebase push через сервер на текущее устройство.';

  @override
  String get notificationsSendTestPush => 'Отправить тестовый push';

  @override
  String get notificationsTaskReminders => 'Напоминания о задачах';

  @override
  String get notificationsTaskRemindersOn =>
      'Вы будете получать напоминания о предстоящих задачах.';

  @override
  String get notificationsTaskRemindersOff =>
      'Напоминания о задачах сейчас выключены.';

  @override
  String get notificationsTaskRemindersNeedsPermission =>
      'Включите системные уведомления, чтобы получать напоминания о задачах.';

  @override
  String get notificationsCalendarReminders => 'Напоминания календаря';

  @override
  String get notificationsCalendarRemindersOn =>
      'Вы будете получать напоминания о предстоящих событиях.';

  @override
  String get notificationsCalendarRemindersOff =>
      'Напоминания календаря сейчас выключены.';

  @override
  String get notificationsCalendarRemindersNeedsPermission =>
      'Включите системные уведомления, чтобы получать напоминания календаря.';

  @override
  String get notificationsCenterTitle => 'Уведомления';

  @override
  String get notificationsBackToHome => 'Назад на главную';

  @override
  String get notificationChannelReminders => 'Напоминания';

  @override
  String get notificationChannelFamily => 'Семейные уведомления';

  @override
  String get notificationChannelDescription =>
      'Подробные напоминания и семейные обновления от Family Helper';

  @override
  String get notificationsSettingsTooltip => 'Настройки уведомлений';

  @override
  String get notificationsLoading => 'Загружаем уведомления...';

  @override
  String get notificationsConnectFamilyTitle =>
      'Подключите семью, чтобы получать обновления';

  @override
  String get notificationsConnectFamilyMessage =>
      'Ваш центр уведомлений оживёт напоминаниями, приглашениями и активностью, как только вы присоединитесь к семье.';

  @override
  String get notificationsOpenFamilySettings => 'Открыть настройки семьи';

  @override
  String get notificationsFilterAll => 'Все';

  @override
  String get notificationsFilterUnread => 'Непрочитанные';

  @override
  String get notificationsHeroTitle => 'Семейный inbox';

  @override
  String notificationsHeroUnread(int count) {
    return '$count непрочитанных';
  }

  @override
  String get notificationsHeroAllRead => 'Всё прочитано';

  @override
  String get notificationsHeroReady => 'Готово к новым обновлениям';

  @override
  String get notificationsHeroSubtitle =>
      'Отдельное место для напоминаний, обновлений и семейной активности, которым стоит уделить внимание.';

  @override
  String get notificationsMarkAllRead => 'Отметить всё прочитанным';

  @override
  String get notificationsNoUnreadTitle => 'Непрочитанных уведомлений нет';

  @override
  String get notificationsNoUnreadMessage =>
      'Всё в семейном inbox уже было открыто.';

  @override
  String get notificationsNoItemsTitle => 'Уведомлений пока нет';

  @override
  String get notificationsNoItemsMessage =>
      'Новые напоминания и семейная активность появятся здесь, как только они поступят.';

  @override
  String get notificationsShowAll => 'Показать все уведомления';

  @override
  String get notificationsLoadMore => 'Загрузить ещё';

  @override
  String get notificationsDetailSelect => 'Выберите уведомление';

  @override
  String get notificationsDetailSelectMessage =>
      'Выберите любое обновление из inbox, чтобы увидеть полный текст и связанное действие.';

  @override
  String get notificationsDetailPlaceholderTitle =>
      'Здесь появятся детали уведомления';

  @override
  String get notificationsDetailPlaceholderMessage =>
      'Когда придут новые напоминания или семейная активность, вы сможете посмотреть здесь полный контекст.';

  @override
  String get notificationsRead => 'Прочитано';

  @override
  String get notificationsUnread => 'Не прочитано';

  @override
  String get notificationsDetailNoTarget =>
      'У этого обновления нет связанной точки перехода, но полный текст сохранён здесь для справки.';

  @override
  String get notificationCategoryReminder => 'Напоминание';

  @override
  String get notificationCategoryTaskAssigned => 'Назначенная задача';

  @override
  String get notificationCategoryTaskCompleted => 'Завершённая задача';

  @override
  String get notificationCategoryCalendarUpdate => 'Обновление календаря';

  @override
  String get notificationCategoryCalendarCancelled => 'Календарь: отмена';

  @override
  String get notificationCategoryFamilyInvite => 'Приглашение в семью';

  @override
  String get notificationCategoryFamilyUpdate => 'Обновление семьи';

  @override
  String get notificationCategoryTestPush => 'Тестовый push';

  @override
  String get notificationCategoryGeneric => 'Уведомление';

  @override
  String get notificationOpenTask => 'Открыть задачу';

  @override
  String get notificationOpenCalendar => 'Открыть календарь';

  @override
  String get notificationOpenList => 'Открыть список';

  @override
  String get notificationOpenGoal => 'Открыть цель';

  @override
  String get notificationOpenNotification => 'Открыть уведомление';

  @override
  String get notificationPermissionNotSetUp => 'Не настроено';

  @override
  String get notificationPermissionAllowed => 'Разрешено';

  @override
  String get notificationPermissionBlocked => 'Заблокировано';

  @override
  String get notificationPermissionBlockedInSettings =>
      'Заблокировано в настройках';

  @override
  String get notificationPermissionAllowAction => 'Разрешить уведомления';

  @override
  String get notificationPermissionEnabledAction => 'Уведомления включены';

  @override
  String get notificationPermissionOpenSettingsAction =>
      'Открыть системные настройки';

  @override
  String get notificationPermissionNotSetUpDescription =>
      'Включите уведомления, чтобы Family Helper мог напоминать вам о задачах и событиях.';

  @override
  String get notificationPermissionAllowedDescription =>
      'Уведомления включены для этого устройства.';

  @override
  String get notificationPermissionBlockedDescription =>
      'Уведомления были отклонены. Откройте системные настройки, чтобы разрешить их.';

  @override
  String get notificationPermissionBlockedInSettingsDescription =>
      'Уведомления выключены в системных настройках. Включите их там снова, чтобы получать напоминания.';

  @override
  String get notificationPresetNone => 'Без напоминания';

  @override
  String get notificationPresetAtTime => 'В момент события';

  @override
  String get notificationPresetTenMinutesBefore => 'За 10 минут';

  @override
  String get notificationPresetOneHourBefore => 'За 1 час';

  @override
  String get notificationPresetOneDayBefore => 'За 1 день';

  @override
  String get notificationFamilyNotSelected => 'Семья не выбрана.';

  @override
  String get notificationReminderQueued =>
      'Напоминание синхронизируется, когда соединение восстановится.';

  @override
  String get notificationSaveReminderFailed =>
      'Не удалось сохранить напоминание.';

  @override
  String get notificationAllowReminderPermission =>
      'Разрешите уведомления, чтобы получать напоминания на этом устройстве.';

  @override
  String get notificationBlockedReminderPermission =>
      'Уведомления заблокированы. Откройте системные настройки, чтобы включить напоминания.';

  @override
  String get notificationDisabledReminderPermission =>
      'Уведомления выключены в системных настройках. Включите их там снова, чтобы получать напоминания.';

  @override
  String get notificationEnableReminderFailed =>
      'Сейчас не удалось включить напоминания. Попробуйте ещё раз.';

  @override
  String get notificationReminderRemoved => 'Напоминание удалено.';

  @override
  String get notificationUpdateReminderFailed =>
      'Не удалось обновить напоминание.';

  @override
  String get notificationDebugOnly =>
      'Тестовые push доступны только в debug-сборках.';

  @override
  String get notificationAllowTestPush =>
      'Разрешите уведомления, чтобы получить тестовый push.';

  @override
  String get notificationBlockedTestPush =>
      'Уведомления заблокированы. Откройте системные настройки, чтобы запустить тест push.';

  @override
  String get notificationDisabledTestPush =>
      'Уведомления выключены в системных настройках. Включите их там снова, чтобы запустить тест push.';

  @override
  String get notificationSelectFamilyForTestPush =>
      'Выберите семью перед отправкой тестового push.';

  @override
  String get notificationTestPushSent =>
      'Тестовый push отправлен. Он должен прийти в ближайшее время.';

  @override
  String get notificationTestPushSkipped =>
      'Тестовый push был создан, но не отправлен. Проверьте регистрацию токена и конфигурацию Firebase на сервере.';

  @override
  String get notificationTestPushFailed =>
      'Не удалось доставить тестовый push. Проверьте логи сервера и конфигурацию Firebase.';

  @override
  String get notificationTestPushRequested => 'Тестовый push запрошен.';

  @override
  String get notificationSendTestPushFailed =>
      'Не удалось отправить тестовый push.';

  @override
  String get notificationPreferenceQueued =>
      'Сеть недоступна. Изменение настроек будет синхронизировано позже.';

  @override
  String get notificationPushTokenQueued =>
      'Сеть недоступна. Регистрация push-токена будет синхронизирована позже.';

  @override
  String get notificationSubtitleReminder => 'Напоминание';

  @override
  String get notificationSubtitleTaskReminder => 'Напоминание о задаче';

  @override
  String get notificationSubtitleCalendarReminder => 'Напоминание о событии';

  @override
  String get notificationSubtitleGoalReminder => 'Напоминание о цели';

  @override
  String get notificationSubtitleListReminder => 'Напоминание о списке';

  @override
  String get notificationSubtitleTaskUpdate => 'Обновление задачи';

  @override
  String get notificationSubtitleCalendarUpdate => 'Обновление календаря';

  @override
  String get notificationSubtitleGoalUpdate => 'Обновление цели';

  @override
  String get notificationSubtitleListUpdate => 'Обновление списка';

  @override
  String get notificationSubtitleFamilyUpdate => 'Обновление семьи';

  @override
  String get notificationSubtitleFamilyNotification => 'Семейное уведомление';

  @override
  String get commonEventReminderTitle => 'Напоминание о событии';

  @override
  String get commonEventReminderBody => 'Семейное событие';

  @override
  String get commonTaskReminderTitle => 'Напоминание о задаче';

  @override
  String get taskPriorityLow => 'Низкий';

  @override
  String get taskPriorityNormal => 'Обычный';

  @override
  String get taskPriorityHigh => 'Высокий';

  @override
  String get taskRepeatNone => 'Без повтора';

  @override
  String get taskRepeatDaily => 'Ежедневно';

  @override
  String get taskRepeatWeekly => 'Еженедельно';

  @override
  String get taskRepeatMonthly => 'Ежемесячно';

  @override
  String get taskDeadlineModeNone => 'Без срока';

  @override
  String get taskDeadlineModeSpecificDate => 'Конкретная дата';

  @override
  String get taskDeadlineModeIn => 'Через...';

  @override
  String get taskOffsetUnitMinutes => 'Минуты';

  @override
  String get taskOffsetUnitHours => 'Часы';

  @override
  String get taskOffsetUnitDays => 'Дни';

  @override
  String get taskEditorCreateTitle => 'Создать задачу';

  @override
  String get taskEditorEditTitle => 'Редактировать задачу';

  @override
  String get taskEditorCreateSubtitle =>
      'Создайте семейную задачу с необязательным сроком, повторением и напоминаниями.';

  @override
  String get taskEditorEditSubtitle =>
      'Обновите назначение, срок, повторение и параметры напоминаний.';

  @override
  String get taskEditorTitleLabel => 'Название задачи';

  @override
  String get taskEditorTitleHint => 'Подготовить список покупок на неделю';

  @override
  String get taskEditorTitleValidation => 'Введите название задачи.';

  @override
  String get taskEditorDescriptionLabel => 'Описание';

  @override
  String get taskEditorDescriptionHint => 'Необязательная заметка для семьи';

  @override
  String get taskEditorPersonalTaskLabel => 'Личная задача';

  @override
  String get taskEditorPersonalTaskOn => 'Эту задачу будете видеть только вы.';

  @override
  String get taskEditorPersonalTaskOff => 'Общие задачи видны всей семье.';

  @override
  String get taskEditorPriorityLabel => 'Приоритет';

  @override
  String get taskEditorUnassigned => 'Без исполнителя';

  @override
  String get taskEditorDeadlineLabel => 'Срок';

  @override
  String get taskEditorNoDeadlineDescription => 'У этой задачи не будет срока.';

  @override
  String get taskEditorDueAtLabel => 'Срок до';

  @override
  String get taskEditorAmountLabel => 'Количество';

  @override
  String get taskEditorAmountHint => '1';

  @override
  String get taskEditorPositiveNumberValidation =>
      'Введите положительное число.';

  @override
  String get taskEditorUnitLabel => 'Единица';

  @override
  String get taskEditorDeadlinePreviewInvalid =>
      'Введите корректное значение, чтобы рассчитать срок.';

  @override
  String taskEditorDeadlinePreview(String date) {
    return 'Срок наступит $date';
  }

  @override
  String get taskEditorReminderLabel => 'Напоминание';

  @override
  String get taskEditorRepeatLabel => 'Повтор';

  @override
  String get taskEditorIntervalLabel => 'Интервал';

  @override
  String get taskEditorSaveChanges => 'Сохранить изменения';

  @override
  String get taskEditorCreateAction => 'Создать задачу';

  @override
  String get taskEditorDeadlineMissingMessage =>
      'Выберите дату и время срока или переключитесь на режим без срока.';

  @override
  String get taskEditorDeadlineRequiredMessage =>
      'Сначала задайте срок, а потом добавляйте напоминания или повторение.';

  @override
  String get taskEditorRelativePresetThirtyMinutes => '30 мин';

  @override
  String get taskEditorRelativePresetOneHour => '1 час';

  @override
  String get taskEditorRelativePresetThreeHours => '3 часа';

  @override
  String get taskEditorRelativePresetOneDay => '1 день';

  @override
  String get taskEditorRelativePresetThreeDays => '3 дня';

  @override
  String get commonSaveChanges => 'Сохранить изменения';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonNote => 'Заметка';

  @override
  String get commonJustNow => 'только что';

  @override
  String get commonShowMore => 'Показать ещё';

  @override
  String get commonShowLess => 'Скрыть';

  @override
  String get commonOverview => 'Обзор';

  @override
  String get commonHistory => 'История';

  @override
  String get commonSettings => 'Настройки';

  @override
  String get listsFamilyFallback => 'Семейное пространство';

  @override
  String get listsYourListsTitle => 'Ваши списки';

  @override
  String get listsYourListsSubtitle =>
      'Выберите список и держите все отметки на виду.';

  @override
  String get listsEmptyTitle => 'Списков пока нет';

  @override
  String get listsEmptyMessage =>
      'Начните со списка покупок или wishlist для семьи.';

  @override
  String get listsCreateFirstList => 'Создать первый список';

  @override
  String get listsDetailsTitle => 'Детали списка';

  @override
  String get listsDetailsSubtitle =>
      'Выберите или создайте список, чтобы начать добавлять пункты.';

  @override
  String get listsListActionsTooltip => 'Действия со списком';

  @override
  String get listsEditListAction => 'Изменить список';

  @override
  String get listsDeleteListAction => 'Удалить список';

  @override
  String get listsNoSelectionTitle => 'Список не выбран';

  @override
  String get listsNoSelectionMessage =>
      'Создайте первый список, чтобы начать планировать вместе.';

  @override
  String get listsCreateSheetTitle => 'Создать новый список';

  @override
  String get listsEditSheetTitle => 'Изменить список';

  @override
  String get listsCreateListAction => 'Создать список';

  @override
  String get listsAddItemTitle => 'Добавить пункт';

  @override
  String get listsEditItemTitle => 'Изменить пункт';

  @override
  String get listsAddToListAction => 'Добавить в список';

  @override
  String get listsDeleteListTitle => 'Удалить список?';

  @override
  String listsDeleteListMessage(String title) {
    return 'Это удалит $title и все его пункты.';
  }

  @override
  String get listsDeleteItemTitle => 'Удалить пункт?';

  @override
  String listsDeleteItemMessage(String title) {
    return 'Убрать $title из этого списка?';
  }

  @override
  String get listsHeroTitle => 'Общие списки, в которых чувствуется жизнь.';

  @override
  String get listsHeroEmptyMessage =>
      'Создайте первую доску покупок или wishlist и держите все отметки на виду.';

  @override
  String listsHeroCountMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активных списка с понятной ответственностью.',
      many: '$count активных списков с понятной ответственностью.',
      few: '$count активных списка с понятной ответственностью.',
      one: '$count активный список с понятной ответственностью.',
    );
    return '$_temp0';
  }

  @override
  String get listsNewList => 'Новый список';

  @override
  String get listsMetricOpen => 'Открыто';

  @override
  String get listsMetricUpdated => 'Обновлено';

  @override
  String get listsStartFirstItem => 'Начните с первого пункта';

  @override
  String listsItemsStillOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пункта ещё открыты',
      many: '$count пунктов ещё открыто',
      few: '$count пункта ещё открыты',
      one: '$count пункт ещё открыт',
    );
    return '$_temp0';
  }

  @override
  String get listsReadyTitle => 'Список готов';

  @override
  String listsReadyMessage(String title) {
    return 'Добавьте первый пункт в $title и сделайте его видимым для всех.';
  }

  @override
  String get listsAddFirstItem => 'Добавить первый пункт';

  @override
  String listsMarkedBy(String name, String time) {
    return 'Отметил $name • $time';
  }

  @override
  String get listsItemActionsTooltip => 'Действия с пунктом';

  @override
  String get listsEditItemAction => 'Изменить пункт';

  @override
  String get listsDeleteItemAction => 'Удалить пункт';

  @override
  String get listsCreateSheetSubtitle =>
      'Выберите шаблон и сделайте список удобным для всей семьи.';

  @override
  String get listsListTitleLabel => 'Название списка';

  @override
  String get listsListTitleHint => 'Покупки на субботу';

  @override
  String listsAddItemSubtitle(String title) {
    return 'Всё, что вы добавите здесь, появится в $title.';
  }

  @override
  String get listsItemTitleLabel => 'Название пункта';

  @override
  String get listsItemTitleHint => 'Молоко';

  @override
  String get listsQtyLabel => 'Кол-во';

  @override
  String get listsUnitLabel => 'Единица';

  @override
  String get listsUnitHint => 'шт / кг';

  @override
  String get listsNoteHint => 'Например, если будет в наличии';

  @override
  String get listsPriceLabel => 'Цена';

  @override
  String get listsTypeWishlist => 'Wishlist';

  @override
  String listsSelectedSubtitle(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count открытых пункта',
      many: '$count открытых пунктов',
      few: '$count открытых пункта',
      one: '$count открытый пункт',
    );
    return '$_temp0 • обновлено $time';
  }

  @override
  String get familyNameUpdated => 'Название семьи обновлено';

  @override
  String get familyInviteCodeCopied => 'Код приглашения скопирован';

  @override
  String get familyLeaveAction => 'Покинуть семью';

  @override
  String get familyTransferBeforeLeave =>
      'Перед выходом из семьи передайте владение другому участнику.';

  @override
  String get familyEmptyTitle => 'Семья не подключена';

  @override
  String get familyEmptyMessage =>
      'Создайте семью или присоединитесь к ней по коду приглашения.';

  @override
  String get familyCreateTitle => 'Создать семью';

  @override
  String get familyNameLabel => 'Название семьи';

  @override
  String get familyCreateAction => 'Создать семью';

  @override
  String get familyJoinTitle => 'Войти по приглашению';

  @override
  String get familyInviteCodeLabel => 'Код приглашения';

  @override
  String get familyJoinAction => 'Присоединиться';

  @override
  String familyMembersInFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участника в семье',
      many: '$count участников в семье',
      few: '$count участника в семье',
      one: '$count участник в семье',
    );
    return '$_temp0';
  }

  @override
  String get familySaveNameAction => 'Сохранить название семьи';

  @override
  String get familyInviteMembersTitle => 'Пригласить членов семьи';

  @override
  String get familyInviteByEmailLabel => 'Пригласить по email';

  @override
  String get familySendEmailInvite => 'Отправить приглашение по email';

  @override
  String get familyCreateInviteCode => 'Создать код приглашения';

  @override
  String familyShareInviteCode(String code) {
    return 'Поделитесь этим кодом приглашения: $code';
  }

  @override
  String get familyCopyInviteCode => 'Скопировать код приглашения';

  @override
  String get familyMembersTitle => 'Члены семьи';

  @override
  String get familyNoMembersYet => 'Участников пока нет';

  @override
  String familyMemberYou(String name) {
    return '$name (Вы)';
  }

  @override
  String get familyRoleOwner => 'Владелец';

  @override
  String get familyRoleMember => 'Участник';

  @override
  String get familyStatusActive => 'Активен';

  @override
  String get familyStatusLeft => 'Вышел';

  @override
  String get familyTransferNeedAnotherMember =>
      'Добавьте ещё одного активного участника, прежде чем передавать владение.';

  @override
  String get familyTransferOwnershipTitle => 'Передать владение';

  @override
  String get familyNewOwnerLabel => 'Новый владелец';

  @override
  String get familyTransferOwnershipAction => 'Передать владение';

  @override
  String get privacyAnalyticsTitle => 'Делиться анонимной аналитикой';

  @override
  String get privacyAnalyticsSubtitle =>
      'Помогите улучшать приложение с помощью агрегированной информации об использовании.';

  @override
  String get privacyDeletionCancelled => 'Запрос на удаление отменён';

  @override
  String get privacyDeletionCompleted => 'Удаление завершено.';

  @override
  String get privacyDataExportTitle => 'Экспорт данных';

  @override
  String get privacyDownloadExport => 'Скачать экспорт';

  @override
  String get privacyAccountDeletionTitle => 'Удаление аккаунта';

  @override
  String get privacyNoRequestsTitle => 'Активных privacy-запросов нет';

  @override
  String get privacyNoRequestsMessage =>
      'Запросите экспорт или удаление аккаунта, когда это понадобится.';

  @override
  String privacyAvailableUntil(String date) {
    return 'Доступно до $date.';
  }

  @override
  String get privacyExportExpiredMessage =>
      'Срок действия экспорта истёк. Запросите новый экспорт, чтобы получить свежую ссылку.';

  @override
  String get privacyExportFailedMessage =>
      'Не удалось подготовить экспорт. Запросите новый экспорт и попробуйте снова.';

  @override
  String get privacyPreparingExportMessage =>
      'Подготавливаем экспорт. Мы покажем его, когда он будет готов.';

  @override
  String privacyPreparingExportRequestedOn(String date) {
    return 'Подготавливаем экспорт. Запрошено $date.';
  }

  @override
  String privacyDeletionScheduledFor(String date) {
    return 'Удаление запланировано на $date.';
  }

  @override
  String get privacyDownloadDialogMessage =>
      'Используйте эту защищённую ссылку в браузере, чтобы скачать архив экспорта.';

  @override
  String get privacyDownloadLinkCopied => 'Ссылка на скачивание скопирована';

  @override
  String get privacyCopyLink => 'Скопировать ссылку';

  @override
  String get privacyYourDataTitle => 'Ваши данные';

  @override
  String get privacyRequestExport => 'Запросить экспорт данных';

  @override
  String get privacyRequestDeletion => 'Запросить удаление аккаунта';

  @override
  String get privacyCancelDeletionRequest => 'Отменить запрос на удаление';

  @override
  String get mediaTitle => 'Медиа и аватары';

  @override
  String get mediaReload => 'Обновить медиа';

  @override
  String get mediaUploadImage => 'Выбрать, обрезать и загрузить изображение';

  @override
  String mediaLastMediaId(String id) {
    return 'Последний media id: $id';
  }

  @override
  String get mediaEmptyTitle => 'Медиа-объектов нет';

  @override
  String get mediaEmptyMessage =>
      'Загрузите изображение, чтобы заполнить историю медиа.';

  @override
  String mediaItemTitle(int id) {
    return 'Медиа #$id';
  }

  @override
  String get moneyGoalsSectionTitle => 'Цели';

  @override
  String moneyGoalsSidebarSummary(int activeCount, int archivedCount) {
    return '$activeCount активных, $archivedCount в архиве';
  }

  @override
  String get moneyGoalsActiveSection => 'Активные';

  @override
  String get moneyGoalsArchivedSection => 'Архив';

  @override
  String get moneyGoalsNoFamilyTitle => 'Сначала выберите семью';

  @override
  String get moneyGoalsNoFamilyMessage =>
      'Цели привязаны к выбранной семье. Откройте настройки семьи, чтобы создать её или присоединиться.';

  @override
  String get moneyGoalsOpenFamilySettings => 'Открыть настройки семьи';

  @override
  String get moneyGoalsEmptyTitle => 'Целей пока нет';

  @override
  String get moneyGoalsEmptyMessage =>
      'Создайте первую цель из панели деталей.';

  @override
  String get moneyGoalsCreateFirstGoal => 'Создать первую цель';

  @override
  String get moneyGoalsStatusArchived => 'Архив';

  @override
  String get moneyGoalsStatusReached => 'Достигнута';

  @override
  String get moneyGoalsStatusActive => 'Активна';

  @override
  String moneyGoalsRemainingChip(String amount) {
    return 'Осталось $amount';
  }

  @override
  String moneyGoalsDeadlineChip(String date) {
    return 'Срок $date';
  }

  @override
  String get moneyGoalsCreateSheetTitle => 'Создать новую цель';

  @override
  String get moneyGoalsCreateSheetSubtitle =>
      'Введите название и целевую сумму в обычном денежном формате.';

  @override
  String get moneyGoalsTargetAmountLabel => 'Целевая сумма';

  @override
  String get moneyGoalsCreateGoalAction => 'Создать цель';

  @override
  String get moneyGoalsArchivedReadonlyMessage =>
      'Архивные цели остаются видимыми, но их настройки больше нельзя редактировать.';

  @override
  String get moneyGoalsAddContributionTitle => 'Пополнить цель';

  @override
  String moneyGoalsAddContributionDescription(String title) {
    return 'Разово пополните «$title».';
  }

  @override
  String get moneyGoalsContributionAmountLabel => 'Сумма пополнения';

  @override
  String get moneyGoalsAddContributionAction => 'Пополнить';

  @override
  String get moneyGoalsWithdrawTitle => 'Снять деньги';

  @override
  String moneyGoalsWithdrawDescription(String title) {
    return 'Заберите часть средств из «$title».';
  }

  @override
  String get moneyGoalsWithdrawAmountLabel => 'Сумма снятия';

  @override
  String get moneyGoalsWithdrawAction => 'Снять деньги';

  @override
  String get moneyGoalsGoalTitleLabel => 'Название цели';

  @override
  String get moneyGoalsGoalTitleHint => 'Финансовая подушка';

  @override
  String get moneyGoalsDeadlineLabel => 'Срок';

  @override
  String get moneyGoalsDescriptionLabel => 'Описание';

  @override
  String get moneyGoalsDescriptionHint => 'Необязательная заметка для семьи';

  @override
  String get moneyGoalsRemainingLabel => 'Осталось';

  @override
  String get moneyGoalsCompleteAndArchive => 'Завершить и архивировать';

  @override
  String get moneyGoalsNewGoal => 'Новая цель';

  @override
  String get moneyGoalsProgressTitle => 'Прогресс';

  @override
  String get moneyGoalsRecentActivityTitle => 'Недавняя активность';

  @override
  String get moneyGoalsNoHistoryYet => 'Пополнений или снятий пока не было.';

  @override
  String get moneyGoalsGoalSettingsTitle => 'Настройки цели';

  @override
  String get moneyGoalsArchiveGoalAction => 'Архивировать цель';

  @override
  String get moneyGoalsDeleteGoalAction => 'Удалить цель';

  @override
  String get tasksLoading => 'Загружаем задачи...';

  @override
  String get calendarAddEvent => 'Добавить событие';

  @override
  String get calendarLoading => 'Загружаем ваш календарь...';

  @override
  String get calendarCreateEventTitle => 'Создать событие';

  @override
  String get calendarSaveEvent => 'Сохранить событие';

  @override
  String get uiErrorFamilyNotSelected => 'Семья не выбрана.';

  @override
  String get uiErrorFamilyTaskNotSelected => 'Семья или задача не выбрана.';

  @override
  String get uiErrorFamilyGoalNotSelected => 'Семья или цель не выбрана.';

  @override
  String get uiErrorArchivedGoalCannotBeEdited =>
      'Архивные цели нельзя редактировать.';

  @override
  String get uiErrorFamilyNameEmpty => 'Название семьи не может быть пустым.';

  @override
  String get uiErrorFamilyRenameQueued =>
      'Сеть недоступна. Переименование семьи будет синхронизировано позже.';

  @override
  String get uiErrorFamilyTransferQueued =>
      'Сеть недоступна. Передача владения будет синхронизирована позже.';

  @override
  String get uiErrorFamilyLeaveQueued =>
      'Сеть недоступна. Выход из семьи будет синхронизирован позже.';

  @override
  String get uiErrorPrivacyExportQueued =>
      'Сеть недоступна. Запрос на экспорт будет синхронизирован позже.';

  @override
  String get uiErrorPrivacyDeletionQueued =>
      'Сеть недоступна. Запрос на удаление будет синхронизирован позже.';

  @override
  String get uiErrorMediaDeleteQueued =>
      'Сеть недоступна. Удаление будет синхронизировано позже.';

  @override
  String get uiErrorExportProcessing =>
      'Экспорт ещё готовится. Загляните чуть позже.';

  @override
  String get commonClear => 'Очистить';

  @override
  String get moneyGoalsLoading => 'Загружаем цели...';

  @override
  String get moneyGoalsEmptyDetailMessage =>
      'Создайте первую цель накоплений и начните отслеживать прогресс.';

  @override
  String get moneyGoalsPickGoalTitle => 'Выберите цель';

  @override
  String get moneyGoalsPickGoalMessage =>
      'Выберите цель из активного списка или архива, чтобы посмотреть прогресс и действия.';

  @override
  String get moneyGoalsCreateAnotherGoal => 'Создать ещё одну цель';

  @override
  String get moneyGoalsNoDeadlineSet => 'Срок не задан';

  @override
  String get moneyGoalsPickDate => 'Выбрать дату';

  @override
  String get moneyGoalsGoalTitleValidation => 'Введите название цели';

  @override
  String get moneyGoalsAmountValidation => 'Введите корректную сумму';

  @override
  String get taskEditorAssigneeLabel => 'Исполнитель';

  @override
  String get tasksSummaryOpen => 'Открытые';

  @override
  String get tasksSummaryDueToday => 'На сегодня';

  @override
  String get tasksSummaryOverdue => 'Просроченные';

  @override
  String get tasksSummaryArchive => 'Архив';

  @override
  String get tasksEmptyArchiveTitle => 'Архив пуст';

  @override
  String get tasksEmptyArchiveMessage =>
      'Завершённые задачи появятся здесь, как только что-то будет закрыто.';

  @override
  String get tasksEmptyFilteredTitle => 'Для этого фильтра задач нет';

  @override
  String get tasksEmptyFilteredMessage =>
      'Попробуйте другой фильтр или создайте новую задачу.';

  @override
  String tasksTaskCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String get tasksPickTaskTitle => 'Выберите задачу';

  @override
  String get tasksPickTaskMessage =>
      'Выберите задачу в рабочей области, чтобы посмотреть детали, напоминания и историю.';

  @override
  String get tasksDetailCompletedItem => 'Завершённая задача';

  @override
  String get tasksDetailOpenFamilyTask => 'Открытая семейная задача';

  @override
  String get tasksMetaPersonal => 'Личная';

  @override
  String get tasksMetaShared => 'Общая';

  @override
  String get tasksActionComplete => 'Завершить';

  @override
  String get tasksActionEdit => 'Изменить';

  @override
  String get tasksActionDelete => 'Удалить';

  @override
  String get tasksHistoryTitle => 'История';

  @override
  String get tasksNoHistoryTitle => 'Истории пока нет';

  @override
  String get tasksNoHistoryMessage =>
      'Здесь появятся изменения и отметки о выполнении.';

  @override
  String get tasksStatusCompleted => 'Завершена';

  @override
  String get tasksStatusOpen => 'Открыта';

  @override
  String get tasksNoFamilyTitle => 'Сначала выберите семью';

  @override
  String get tasksNoFamilyMessage =>
      'Задачи привязаны к выбранной семье. Откройте настройки семьи, чтобы создать её или присоединиться.';

  @override
  String get tasksOpenFamilySettings => 'Открыть настройки семьи';

  @override
  String get tasksSectionOverdue => 'Просроченные';

  @override
  String get tasksSectionToday => 'Сегодня';

  @override
  String get tasksSectionUpcoming => 'Скоро';

  @override
  String get tasksSectionNoDueDate => 'Без срока';

  @override
  String get tasksFilterAllOpen => 'Все открытые';

  @override
  String get tasksFilterMine => 'Мои';

  @override
  String get tasksFilterUnassigned => 'Без исполнителя';

  @override
  String get tasksFilterDueSoon => 'Скоро срок';

  @override
  String get tasksFilterCompletedArchive => 'Архив завершённых';

  @override
  String get tasksHistoryCreated => 'Создана';

  @override
  String get tasksHistoryUpdated => 'Обновлена';

  @override
  String get tasksHistoryCompleted => 'Завершена';

  @override
  String get tasksHistoryDeleted => 'Удалена';

  @override
  String get tasksHistoryDetailsCreated => 'Задача создана';

  @override
  String get tasksHistoryDetailsUpdated => 'Задача обновлена';

  @override
  String get tasksHistoryDetailsCompleted => 'Задача завершена';

  @override
  String get tasksHistoryDetailsDeleted => 'Задача удалена';

  @override
  String get tasksHistoryDetailsCreatedFromRecurrence =>
      'Задача создана повтором';

  @override
  String tasksAssigneeMemberYou(String name) {
    return '$name (вы)';
  }

  @override
  String get tasksAssigneeYou => 'Вы';

  @override
  String tasksAssigneeUser(int profileId) {
    return 'Пользователь $profileId';
  }

  @override
  String get tasksNoDueDate => 'Без срока';

  @override
  String tasksDueChip(String date) {
    return 'Срок: $date';
  }

  @override
  String get tasksOfflineUnavailable => 'Задачи недоступны в офлайне.';

  @override
  String get tasksDeleteTaskTitle => 'Удалить задачу';

  @override
  String tasksDeleteTaskDescription(String title) {
    return 'Удалить «$title» навсегда из активных задач и архива.';
  }

  @override
  String get tasksDeleteTaskConfirm => 'Удалить задачу';

  @override
  String get moneyGoalsSummaryTitle => 'Сводка по целям';

  @override
  String get moneyGoalsSummaryActiveGoals => 'Активные цели';

  @override
  String get moneyGoalsSummaryArchived => 'Архив';

  @override
  String get moneyGoalsSummaryCompleted => 'Достигнуты';

  @override
  String get moneyGoalsSummarySavedTotal => 'Накоплено всего';

  @override
  String moneyGoalsGoalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count цели',
      many: '$count целей',
      few: '$count цели',
      one: '$count цель',
    );
    return '$_temp0';
  }

  @override
  String get moneyGoalsNoActiveGoalsMessage =>
      'Активных целей сейчас нет. Архивные цели остаются ниже для справки.';

  @override
  String get moneyGoalsArchiveGoalConfirmTitle => 'Архивировать цель';

  @override
  String moneyGoalsArchiveGoalConfirmDescription(String title) {
    return 'Архивировать «$title»? Цель останется видимой, но редактирование будет заблокировано.';
  }

  @override
  String get moneyGoalsDeleteGoalConfirmTitle => 'Удалить цель';

  @override
  String moneyGoalsDeleteGoalConfirmDescription(String title) {
    return 'Удалить «$title» навсегда из активных и архивных целей.';
  }

  @override
  String moneyGoalsProgressOf(String current, String target) {
    return '$current из $target';
  }

  @override
  String moneyGoalsStatusArchivedOn(String date) {
    return 'В архиве с $date';
  }

  @override
  String moneyGoalsStatusReachedOn(String date) {
    return 'Достигнута $date';
  }

  @override
  String moneyGoalsStatusUpdatedAt(String date) {
    return 'Обновлено $date';
  }

  @override
  String moneyGoalsHistoryWithdrew(String name, String amount) {
    return '$name вывел(а) $amount';
  }

  @override
  String moneyGoalsHistoryAdded(String name, String amount) {
    return '$name добавил(а) $amount';
  }

  @override
  String get calendarEditOccurrenceTitle => 'Изменить вхождение';

  @override
  String get calendarEditFollowingTitle => 'Изменить это и следующие';

  @override
  String get calendarEditWholeSeriesTitle => 'Изменить всю серию';

  @override
  String get calendarDeleteOccurrenceTitle => 'Удалить вхождение';

  @override
  String get calendarDeleteOccurrenceMessage =>
      'Удалить только это вхождение из серии?';

  @override
  String get calendarDeleteSeriesFutureMessage =>
      'Удалить это и все следующие вхождения?';

  @override
  String get calendarDeleteSeriesAllMessage =>
      'Удалить всю повторяющуюся серию?';

  @override
  String get calendarDeleteEventTitle => 'Удалить событие';

  @override
  String get calendarOfflineMessage =>
      'Это действие синхронизируется, когда соединение восстановится.';

  @override
  String get calendarYourScheduleTitle => 'Ваше расписание';

  @override
  String get calendarUpdatingStatus => 'Обновляем';

  @override
  String get calendarRefreshingStatus => 'Загружаем';

  @override
  String get calendarSavingStatus => 'Сохраняем';

  @override
  String get calendarFormatMonth => 'Месяц';

  @override
  String calendarPlansForDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count плана на этот день',
      many: '$count планов на этот день',
      few: '$count плана на этот день',
      one: '$count план на этот день',
    );
    return '$_temp0';
  }

  @override
  String get calendarOpenDayTitle => 'Свободный день';

  @override
  String calendarNextEventSummary(String timeRange, String title) {
    return 'Дальше: $timeRange • $title';
  }

  @override
  String get calendarOpenDayEmptyMessage =>
      'Пока ничего не запланировано. Добавьте событие, чтобы держать день в порядке.';

  @override
  String get calendarAgendaTitle => 'План на день';

  @override
  String calendarEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count события',
      many: '$count событий',
      few: '$count события',
      one: '$count событие',
    );
    return '$_temp0';
  }

  @override
  String get calendarEmptyDayTitle => 'Пока ничего не запланировано';

  @override
  String get calendarEmptyDayMessage =>
      'Создайте событие на этот день, и оно появится здесь с нужным повтором и напоминанием.';

  @override
  String get calendarRepeatsChip => 'Повтор';

  @override
  String get calendarEditedChip => 'Изменено';

  @override
  String get calendarReminderAtTime => 'В момент события';

  @override
  String get calendarReminderTenMinutesBefore => 'За 10 мин';

  @override
  String get calendarReminderOneHourBefore => 'За 1 ч';

  @override
  String get calendarReminderOneDayBefore => 'За 1 день';

  @override
  String get calendarReminderGeneric => 'Напоминание';

  @override
  String get calendarActionEditSection => 'Изменить';

  @override
  String get calendarActionDeleteSection => 'Удалить';

  @override
  String get calendarActionEditOccurrence => 'Изменить это вхождение';

  @override
  String get calendarActionEditFollowing => 'Изменить это и следующие';

  @override
  String get calendarActionEditWholeSeries => 'Изменить всю серию';

  @override
  String get calendarActionEditEvent => 'Изменить событие';

  @override
  String get calendarActionDeleteOccurrence => 'Удалить это вхождение';

  @override
  String get calendarActionDeleteFollowing => 'Удалить это и следующие';

  @override
  String get calendarActionDeleteWholeSeries => 'Удалить всю серию';

  @override
  String get calendarActionDeleteEvent => 'Удалить событие';

  @override
  String get calendarEditorRecurringSubtitle =>
      'Настройте время, напоминания и правила повтора в одном месте.';

  @override
  String get calendarEditorSingleSubtitle =>
      'Обновите только это вхождение, не меняя всю серию.';

  @override
  String get calendarEditorBasicsTitle => 'Основное';

  @override
  String get calendarEditorBasicsSubtitle =>
      'Понятное название помогает всей семье быстрее ориентироваться в дне.';

  @override
  String get calendarEditorTitleLabel => 'Название события';

  @override
  String get calendarEditorNotesLabel => 'Заметки';

  @override
  String get calendarEditorOptionalHint => 'Необязательно';

  @override
  String get calendarEditorScheduleTitle => 'Расписание';

  @override
  String get calendarEditorScheduleSubtitle =>
      'Выберите аккуратное время начала и окончания события.';

  @override
  String get calendarEditorStartsLabel => 'Начало';

  @override
  String get calendarEditorEndsLabel => 'Окончание';

  @override
  String get calendarEditorReminderTitle => 'Напоминание';

  @override
  String get calendarEditorReminderSubtitle =>
      'Уведомления должны приходить только тогда, когда они действительно полезны.';

  @override
  String get calendarEditorRepeatTitle => 'Повтор';

  @override
  String get calendarEditorRepeatSubtitle =>
      'Держите правила повтора на виду и показывайте только нужные элементы управления.';

  @override
  String get calendarEditorDaysOfWeekLabel => 'Дни недели';

  @override
  String get calendarEditorRepeatEveryDaysLabel => 'Повторять каждые N дней';

  @override
  String get calendarEditorTitleValidation => 'Добавьте название события.';

  @override
  String get calendarEditorEndAfterStartValidation =>
      'Время окончания должно быть позже начала.';

  @override
  String get calendarEditorIntervalValidation =>
      'Интервал повтора должен быть не меньше 1 дня.';

  @override
  String get calendarRecurrenceNoneTitle => 'Без повтора';

  @override
  String get calendarRecurrenceYearlyTitle => 'Каждый год в этот день';

  @override
  String get calendarRecurrenceMonthlyTitle => 'Каждый месяц в это число';

  @override
  String get calendarRecurrenceWeeklyTitle => 'Выбранные дни недели';

  @override
  String get calendarRecurrenceEveryNDaysTitle => 'Каждые N дней';

  @override
  String get calendarRecurrenceNoneSubtitle => 'Разовое событие.';

  @override
  String get calendarRecurrenceYearlySubtitle =>
      'Подходит для дней рождения и годовщин.';

  @override
  String get calendarRecurrenceMonthlySubtitle =>
      'Повторяется в то же число каждого месяца.';

  @override
  String get calendarRecurrenceWeeklySubtitle =>
      'Выберите один или несколько дней недели.';

  @override
  String get calendarRecurrenceEveryNDaysSubtitle =>
      'Подходит для рутин с фиксированным интервалом.';

  @override
  String calendarDurationHours(int hours) {
    return '$hours ч';
  }

  @override
  String calendarDurationHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String calendarDurationMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String get calendarMutationScopeOne => 'Это вхождение';

  @override
  String get calendarMutationScopeFuture => 'Это и следующие';

  @override
  String get calendarMutationScopeAll => 'Вся серия';
}
