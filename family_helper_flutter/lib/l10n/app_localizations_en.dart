// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Family Helper';

  @override
  String get bootstrapUnableToStart => 'Unable to start the app.';

  @override
  String get bootstrapPreparingSpace => 'Preparing your space...';

  @override
  String get notificationActionTooltip => 'Notifications';

  @override
  String get serverUnavailableBanner =>
      'Server unavailable. Some actions may not work until connection is restored.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsProfileTitle => 'Profile';

  @override
  String get settingsFamilyTitle => 'Family';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsPrivacyTitle => 'Privacy';

  @override
  String get settingsLanguageTitle => 'App language';

  @override
  String get settingsLanguageSubtitle =>
      'Choose how Family Helper picks the language for this device and your notifications.';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String settingsCurrentMode(String mode) {
    return 'Current mode: $mode';
  }

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsProfileSummaryLoading => 'Loading profile...';

  @override
  String get settingsProfileSummaryEmpty =>
      'Update your name, timezone, and photo';

  @override
  String get settingsPhotoMissing => 'No photo';

  @override
  String get settingsPhotoAdded => 'Photo added';

  @override
  String get settingsFamilySummaryNotConnected => 'Not connected';

  @override
  String get settingsFamilySummaryLoading => 'Loading family...';

  @override
  String get settingsFamilySummaryConnected => 'Family connected';

  @override
  String settingsMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '$count member',
    );
    return '$_temp0';
  }

  @override
  String get settingsSwitchOn => 'On';

  @override
  String get settingsSwitchOff => 'Off';

  @override
  String settingsNotificationsSummary(
    String permission,
    String tasks,
    String calendar,
  ) {
    return '$permission • Task $tasks • Calendar $calendar';
  }

  @override
  String get settingsAnalyticsOn => 'Analytics on';

  @override
  String get settingsAnalyticsOff => 'Analytics off';

  @override
  String get settingsDeletionScheduled => 'Deletion scheduled';

  @override
  String get settingsExportReady => 'Export ready';

  @override
  String get settingsExportExpired => 'Export expired';

  @override
  String get settingsExportFailed => 'Export failed';

  @override
  String get settingsPreparingExport => 'Preparing export';

  @override
  String get settingsNoActiveRequests => 'No active requests';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileNotFoundTitle => 'Profile not found';

  @override
  String get profileNotFoundMessage => 'Sign in and refresh profile.';

  @override
  String get profileDisplayNameLabel => 'Display name';

  @override
  String get profileTimezoneLabel => 'Timezone';

  @override
  String get profileSave => 'Save profile';

  @override
  String get profileNoPhotoYet => 'No profile photo yet';

  @override
  String get profilePhoto => 'Profile photo';

  @override
  String get profilePhotoHint =>
      'Use a clear photo so family members can recognize you easily.';

  @override
  String get profileAddPhoto => 'Add photo';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileRemovePhoto => 'Remove photo';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeNoFamilyTitle => 'Build a beautiful family dashboard';

  @override
  String get homeNoFamilyMessage =>
      'Add or join a family to bring shared plans, tasks, shopping lists, and savings goals into one warm home base.';

  @override
  String get homeFeatureSharedCalendar => 'Shared calendar';

  @override
  String get homeFeatureFamilyTasks => 'Family tasks';

  @override
  String get homeFeatureListsSync => 'Lists that stay in sync';

  @override
  String get homeFeatureSavingsGoals => 'Savings goals together';

  @override
  String get homeAddFamily => 'Add family';

  @override
  String get homeHeroFamilyFallback => 'Your family';

  @override
  String get homeHeroSharedDashboard => 'Shared dashboard';

  @override
  String get homeHeroTitle => 'Everything your family needs, at a glance.';

  @override
  String get homeHeroSubtitle =>
      'Start here for the next event, the tasks that need attention, and the goals that are moving forward together.';

  @override
  String get homeTasks => 'Tasks';

  @override
  String get homeCalendar => 'Calendar';

  @override
  String get homeLists => 'Lists';

  @override
  String get homeGoals => 'Goals';

  @override
  String get homeTasksDescription => 'Open tasks ready for focus';

  @override
  String get homeCalendarDescription =>
      'Planned moments on the family timeline';

  @override
  String get homeListsDescription => 'Items still waiting to be checked off';

  @override
  String get homeGoalsDescription => 'Active savings journeys in motion';

  @override
  String get homeComingUp => 'Coming up';

  @override
  String get homeComingUpSubtitle =>
      'The next moments everyone is moving toward.';

  @override
  String get homeNeedsAttention => 'Needs attention';

  @override
  String get homeNeedsAttentionSubtitle =>
      'A quick scan of the tasks most likely to matter next.';

  @override
  String get homeNoUpcomingEventsTitle => 'No upcoming events';

  @override
  String get homeNoUpcomingEventsMessage =>
      'Your next family plans will show up here as soon as something lands on the calendar.';

  @override
  String get homeNoUrgentTasksTitle => 'Nothing urgent right now';

  @override
  String get homeNoUrgentTasksMessage =>
      'When new tasks need attention, they will appear here in priority order.';

  @override
  String get homeNotificationEnableTitle => 'Stay on top of family reminders';

  @override
  String get homeNotificationBlockedTitle => 'Notifications are blocked';

  @override
  String get homeQuickNavigation => 'Quick navigation';

  @override
  String get homeQuickNavigationSubtitle =>
      'Jump straight into the part of the household flow you want to move next.';

  @override
  String get homeSavingsSpotlight => 'Savings spotlight';

  @override
  String get homeNoGoalsTitle => 'No active goals yet';

  @override
  String get homeNoGoalsMessage =>
      'Start a savings goal to keep the family’s next milestone visible every day.';

  @override
  String homeGoalLeft(String amount) {
    return '$amount left';
  }

  @override
  String homeDeadline(String date) {
    return 'Deadline $date';
  }

  @override
  String get homeOpenGoals => 'Open goals';

  @override
  String get homeListsSpotlight => 'Lists spotlight';

  @override
  String get homeNoListsTitle => 'No active lists';

  @override
  String get homeNoListsMessage =>
      'Create a shopping or chore list and it will become part of the dashboard rhythm here.';

  @override
  String homeListItemsOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items open',
      one: '$count item open',
    );
    return '$_temp0';
  }

  @override
  String get homeListEverythingDone => 'Everything here is already wrapped up.';

  @override
  String get homeListMomentum =>
      'A quick place to continue the list that still has the most momentum.';

  @override
  String get homeOpenLists => 'Open lists';

  @override
  String get homeTaskUrgencyNoDate => 'No due date';

  @override
  String get homeTaskUrgencyOverdue => 'Overdue';

  @override
  String get homeTaskUrgencyToday => 'Due today';

  @override
  String get homeTaskUrgencyUpcoming => 'Upcoming';

  @override
  String get homeTaskDueHint => 'Add a due date to prioritize it';

  @override
  String get listTypeShopping => 'Shopping';

  @override
  String get listTypeTodo => 'To-do';

  @override
  String get notificationsSettingsTitle => 'Notification settings';

  @override
  String get notificationsTuneTitle => 'Tune how Family Helper reaches you';

  @override
  String get notificationsTuneSubtitle =>
      'Choose which reminders stay active on this device and keep permission status in a healthy state.';

  @override
  String get notificationsSystemTitle => 'System notifications';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsDebugTitle => 'Debug tools';

  @override
  String get notificationsDebugSubtitle =>
      'Sends a real Firebase push through the server to this signed-in device.';

  @override
  String get notificationsSendTestPush => 'Send test push';

  @override
  String get notificationsTaskReminders => 'Task reminders';

  @override
  String get notificationsTaskRemindersOn =>
      'You will receive reminders for upcoming tasks.';

  @override
  String get notificationsTaskRemindersOff =>
      'Task reminders are currently turned off.';

  @override
  String get notificationsTaskRemindersNeedsPermission =>
      'Turn on device notifications to receive task reminders.';

  @override
  String get notificationsCalendarReminders => 'Calendar reminders';

  @override
  String get notificationsCalendarRemindersOn =>
      'You will receive reminders for upcoming events.';

  @override
  String get notificationsCalendarRemindersOff =>
      'Calendar reminders are currently turned off.';

  @override
  String get notificationsCalendarRemindersNeedsPermission =>
      'Turn on device notifications to receive calendar reminders.';

  @override
  String get notificationsCenterTitle => 'Notifications';

  @override
  String get notificationsBackToHome => 'Back to home';

  @override
  String get notificationChannelReminders => 'Reminders';

  @override
  String get notificationChannelFamily => 'Family notifications';

  @override
  String get notificationChannelDescription =>
      'Rich reminders and family updates from Family Helper';

  @override
  String get notificationsSettingsTooltip => 'Notification settings';

  @override
  String get notificationsLoading => 'Loading notifications...';

  @override
  String get notificationsConnectFamilyTitle =>
      'Connect a family to start receiving updates';

  @override
  String get notificationsConnectFamilyMessage =>
      'Your dedicated notification center will light up with reminders, invites, and activity once you join a family.';

  @override
  String get notificationsOpenFamilySettings => 'Open family settings';

  @override
  String get notificationsFilterAll => 'All';

  @override
  String get notificationsFilterUnread => 'Unread';

  @override
  String get notificationsHeroTitle => 'Family inbox';

  @override
  String notificationsHeroUnread(int count) {
    return '$count unread';
  }

  @override
  String get notificationsHeroAllRead => 'Everything is read';

  @override
  String get notificationsHeroReady => 'Ready for new updates';

  @override
  String get notificationsHeroSubtitle =>
      'A dedicated place for reminders, updates, and family activity that deserves attention.';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsNoUnreadTitle => 'No unread notifications';

  @override
  String get notificationsNoUnreadMessage =>
      'Everything in your family inbox has already been opened.';

  @override
  String get notificationsNoItemsTitle => 'No notifications yet';

  @override
  String get notificationsNoItemsMessage =>
      'New reminders and family activity will show up here as soon as they arrive.';

  @override
  String get notificationsShowAll => 'Show all notifications';

  @override
  String get notificationsLoadMore => 'Load more';

  @override
  String get notificationsDetailSelect => 'Select a notification';

  @override
  String get notificationsDetailSelectMessage =>
      'Choose any update from the inbox to see the full message and related action.';

  @override
  String get notificationsDetailPlaceholderTitle =>
      'Your notification details will appear here';

  @override
  String get notificationsDetailPlaceholderMessage =>
      'Once new reminders or family activity arrive, you will be able to review the full context here.';

  @override
  String get notificationsRead => 'Read';

  @override
  String get notificationsUnread => 'Unread';

  @override
  String get notificationsDetailNoTarget =>
      'This update does not include a linked destination, but the full message is preserved here for reference.';

  @override
  String get notificationCategoryReminder => 'Reminder';

  @override
  String get notificationCategoryTaskAssigned => 'Assigned task';

  @override
  String get notificationCategoryTaskCompleted => 'Completed task';

  @override
  String get notificationCategoryCalendarUpdate => 'Calendar update';

  @override
  String get notificationCategoryCalendarCancelled => 'Calendar cancelled';

  @override
  String get notificationCategoryFamilyInvite => 'Family invite';

  @override
  String get notificationCategoryFamilyUpdate => 'Family update';

  @override
  String get notificationCategoryTestPush => 'Test push';

  @override
  String get notificationCategoryGeneric => 'Notification';

  @override
  String get notificationOpenTask => 'Open task';

  @override
  String get notificationOpenCalendar => 'Open calendar';

  @override
  String get notificationOpenList => 'Open list';

  @override
  String get notificationOpenGoal => 'Open goal';

  @override
  String get notificationOpenNotification => 'Open notification';

  @override
  String get notificationPermissionNotSetUp => 'Not set up';

  @override
  String get notificationPermissionAllowed => 'Allowed';

  @override
  String get notificationPermissionBlocked => 'Blocked';

  @override
  String get notificationPermissionBlockedInSettings => 'Blocked in settings';

  @override
  String get notificationPermissionAllowAction => 'Allow notifications';

  @override
  String get notificationPermissionEnabledAction => 'Notifications enabled';

  @override
  String get notificationPermissionOpenSettingsAction => 'Open system settings';

  @override
  String get notificationPermissionNotSetUpDescription =>
      'Turn on notifications so Family Helper can remind you about tasks and events.';

  @override
  String get notificationPermissionAllowedDescription =>
      'Notifications are enabled for this device.';

  @override
  String get notificationPermissionBlockedDescription =>
      'Notifications were denied. Open system settings to allow them.';

  @override
  String get notificationPermissionBlockedInSettingsDescription =>
      'Notifications are disabled in system settings. Re-enable them there to get reminders.';

  @override
  String get notificationPresetNone => 'No reminder';

  @override
  String get notificationPresetAtTime => 'At time';

  @override
  String get notificationPresetTenMinutesBefore => '10 minutes before';

  @override
  String get notificationPresetOneHourBefore => '1 hour before';

  @override
  String get notificationPresetOneDayBefore => '1 day before';

  @override
  String get notificationFamilyNotSelected => 'Family is not selected.';

  @override
  String get notificationReminderQueued =>
      'Reminder will sync when your connection returns.';

  @override
  String get notificationSaveReminderFailed => 'Unable to save the reminder.';

  @override
  String get notificationAllowReminderPermission =>
      'Allow notifications to receive reminders on this device.';

  @override
  String get notificationBlockedReminderPermission =>
      'Notifications are blocked. Open system settings to enable reminders.';

  @override
  String get notificationDisabledReminderPermission =>
      'Notifications are disabled in system settings. Re-enable them there to get reminders.';

  @override
  String get notificationEnableReminderFailed =>
      'Unable to enable reminders right now. Please try again.';

  @override
  String get notificationReminderRemoved => 'Reminder removed.';

  @override
  String get notificationUpdateReminderFailed =>
      'Unable to update the reminder.';

  @override
  String get notificationDebugOnly =>
      'Test pushes are only available in debug builds.';

  @override
  String get notificationAllowTestPush =>
      'Allow notifications to receive the test push.';

  @override
  String get notificationBlockedTestPush =>
      'Notifications are blocked. Open system settings to run the push test.';

  @override
  String get notificationDisabledTestPush =>
      'Notifications are disabled in system settings. Re-enable them there to run the push test.';

  @override
  String get notificationSelectFamilyForTestPush =>
      'Select a family before sending a test push.';

  @override
  String get notificationTestPushSent =>
      'Test push sent. It should arrive shortly.';

  @override
  String get notificationTestPushSkipped =>
      'Test push was created, but nothing was sent. Check token registration and Firebase server config.';

  @override
  String get notificationTestPushFailed =>
      'Test push dispatch failed. Check server logs and Firebase configuration.';

  @override
  String get notificationTestPushRequested => 'Test push requested.';

  @override
  String get notificationSendTestPushFailed => 'Unable to send the test push.';

  @override
  String get notificationPreferenceQueued =>
      'Network unavailable. Preference change queued.';

  @override
  String get notificationPushTokenQueued =>
      'Network unavailable. Push token registration queued.';

  @override
  String get notificationSubtitleReminder => 'Reminder';

  @override
  String get notificationSubtitleTaskReminder => 'Task reminder';

  @override
  String get notificationSubtitleCalendarReminder => 'Calendar reminder';

  @override
  String get notificationSubtitleGoalReminder => 'Goal reminder';

  @override
  String get notificationSubtitleListReminder => 'List reminder';

  @override
  String get notificationSubtitleTaskUpdate => 'Task update';

  @override
  String get notificationSubtitleCalendarUpdate => 'Calendar update';

  @override
  String get notificationSubtitleGoalUpdate => 'Goal update';

  @override
  String get notificationSubtitleListUpdate => 'List update';

  @override
  String get notificationSubtitleFamilyUpdate => 'Family update';

  @override
  String get notificationSubtitleFamilyNotification => 'Family notification';

  @override
  String get commonEventReminderTitle => 'Event reminder';

  @override
  String get commonEventReminderBody => 'Family event';

  @override
  String get commonTaskReminderTitle => 'Task reminder';

  @override
  String get taskPriorityLow => 'Low';

  @override
  String get taskPriorityNormal => 'Normal';

  @override
  String get taskPriorityHigh => 'High';

  @override
  String get taskRepeatNone => 'Does not repeat';

  @override
  String get taskRepeatDaily => 'Daily';

  @override
  String get taskRepeatWeekly => 'Weekly';

  @override
  String get taskRepeatMonthly => 'Monthly';

  @override
  String get taskDeadlineModeNone => 'No deadline';

  @override
  String get taskDeadlineModeSpecificDate => 'Specific date';

  @override
  String get taskDeadlineModeIn => 'In...';

  @override
  String get taskOffsetUnitMinutes => 'Minutes';

  @override
  String get taskOffsetUnitHours => 'Hours';

  @override
  String get taskOffsetUnitDays => 'Days';

  @override
  String get taskEditorCreateTitle => 'Create task';

  @override
  String get taskEditorEditTitle => 'Edit task';

  @override
  String get taskEditorCreateSubtitle =>
      'Create a family task with an optional deadline, recurrence, and reminders.';

  @override
  String get taskEditorEditSubtitle =>
      'Update assignment, deadline, recurrence, and reminder settings.';

  @override
  String get taskEditorTitleLabel => 'Task title';

  @override
  String get taskEditorTitleHint => 'Prepare the weekly grocery list';

  @override
  String get taskEditorTitleValidation => 'Enter a task title.';

  @override
  String get taskEditorDescriptionLabel => 'Description';

  @override
  String get taskEditorDescriptionHint => 'Optional note for the family';

  @override
  String get taskEditorPersonalTaskLabel => 'Personal task';

  @override
  String get taskEditorPersonalTaskOn => 'Only you will see this task.';

  @override
  String get taskEditorPersonalTaskOff =>
      'Shared tasks stay visible to the whole family.';

  @override
  String get taskEditorPriorityLabel => 'Priority';

  @override
  String get taskEditorUnassigned => 'Unassigned';

  @override
  String get taskEditorDeadlineLabel => 'Deadline';

  @override
  String get taskEditorNoDeadlineDescription =>
      'This task will not have a deadline.';

  @override
  String get taskEditorDueAtLabel => 'Due at';

  @override
  String get taskEditorAmountLabel => 'Amount';

  @override
  String get taskEditorAmountHint => '1';

  @override
  String get taskEditorPositiveNumberValidation => 'Enter a positive number.';

  @override
  String get taskEditorUnitLabel => 'Unit';

  @override
  String get taskEditorDeadlinePreviewInvalid =>
      'Enter a valid offset to calculate the deadline.';

  @override
  String taskEditorDeadlinePreview(String date) {
    return 'Will be due $date';
  }

  @override
  String get taskEditorReminderLabel => 'Reminder';

  @override
  String get taskEditorRepeatLabel => 'Repeat';

  @override
  String get taskEditorIntervalLabel => 'Interval';

  @override
  String get taskEditorSaveChanges => 'Save changes';

  @override
  String get taskEditorCreateAction => 'Create task';

  @override
  String get taskEditorDeadlineMissingMessage =>
      'Pick a deadline date and time or switch to no deadline.';

  @override
  String get taskEditorDeadlineRequiredMessage =>
      'Set a due date before adding reminders or recurrence.';

  @override
  String get taskEditorRelativePresetThirtyMinutes => '30 min';

  @override
  String get taskEditorRelativePresetOneHour => '1 hour';

  @override
  String get taskEditorRelativePresetThreeHours => '3 hours';

  @override
  String get taskEditorRelativePresetOneDay => '1 day';

  @override
  String get taskEditorRelativePresetThreeDays => '3 days';

  @override
  String get commonSaveChanges => 'Save changes';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonNote => 'Note';

  @override
  String get commonJustNow => 'just now';

  @override
  String get commonShowMore => 'Show more';

  @override
  String get commonShowLess => 'Show less';

  @override
  String get commonOverview => 'Overview';

  @override
  String get commonHistory => 'History';

  @override
  String get commonSettings => 'Settings';

  @override
  String get listsFamilyFallback => 'Family collaboration';

  @override
  String get listsYourListsTitle => 'Your lists';

  @override
  String get listsYourListsSubtitle =>
      'Pick a list and keep every check-off visible.';

  @override
  String get listsEmptyTitle => 'No lists yet';

  @override
  String get listsEmptyMessage =>
      'Start with a shopping list or wishlist for your family.';

  @override
  String get listsCreateFirstList => 'Create your first list';

  @override
  String get listsDetailsTitle => 'List details';

  @override
  String get listsDetailsSubtitle =>
      'Choose or create a list to start adding items.';

  @override
  String get listsListActionsTooltip => 'List actions';

  @override
  String get listsEditListAction => 'Edit list';

  @override
  String get listsDeleteListAction => 'Delete list';

  @override
  String get listsNoSelectionTitle => 'No list selected';

  @override
  String get listsNoSelectionMessage =>
      'Create your first list to start planning together.';

  @override
  String get listsCreateSheetTitle => 'Create a new list';

  @override
  String get listsEditSheetTitle => 'Edit list';

  @override
  String get listsCreateListAction => 'Create list';

  @override
  String get listsAddItemTitle => 'Add item';

  @override
  String get listsEditItemTitle => 'Edit item';

  @override
  String get listsAddToListAction => 'Add to list';

  @override
  String get listsDeleteListTitle => 'Delete list?';

  @override
  String listsDeleteListMessage(String title) {
    return 'This will remove $title and all of its items.';
  }

  @override
  String get listsDeleteItemTitle => 'Delete item?';

  @override
  String listsDeleteItemMessage(String title) {
    return 'Remove $title from this list?';
  }

  @override
  String get listsHeroTitle => 'Shared lists that feel alive.';

  @override
  String get listsHeroEmptyMessage =>
      'Create your first shopping or wishlist board and keep every check-off visible.';

  @override
  String listsHeroCountMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active lists with clear ownership.',
      one: '$count active list with clear ownership.',
    );
    return '$_temp0';
  }

  @override
  String get listsNewList => 'New list';

  @override
  String get listsMetricOpen => 'Open';

  @override
  String get listsMetricUpdated => 'Updated';

  @override
  String get listsStartFirstItem => 'Start with your first item';

  @override
  String listsItemsStillOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items still open',
      one: '$count item still open',
    );
    return '$_temp0';
  }

  @override
  String get listsReadyTitle => 'This list is ready';

  @override
  String listsReadyMessage(String title) {
    return 'Add the first item to $title and make it visible to everyone.';
  }

  @override
  String get listsAddFirstItem => 'Add first item';

  @override
  String listsMarkedBy(String name, String time) {
    return 'Marked by $name - $time';
  }

  @override
  String get listsItemActionsTooltip => 'Item actions';

  @override
  String get listsEditItemAction => 'Edit item';

  @override
  String get listsDeleteItemAction => 'Delete item';

  @override
  String get listsCreateSheetSubtitle =>
      'Choose a template and make it easy for the whole family to follow.';

  @override
  String get listsListTitleLabel => 'List title';

  @override
  String get listsListTitleHint => 'Saturday groceries';

  @override
  String listsAddItemSubtitle(String title) {
    return 'Everything added here will show up in $title.';
  }

  @override
  String get listsItemTitleLabel => 'Item title';

  @override
  String get listsItemTitleHint => 'Milk';

  @override
  String get listsQtyLabel => 'Qty';

  @override
  String get listsUnitLabel => 'Unit';

  @override
  String get listsUnitHint => 'pcs / kg';

  @override
  String get listsNoteHint => 'Semi-skimmed if available';

  @override
  String get listsPriceLabel => 'Price';

  @override
  String get listsTypeWishlist => 'Wishlist';

  @override
  String listsSelectedSubtitle(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open items',
      one: '$count open item',
    );
    return '$_temp0 - updated $time';
  }

  @override
  String get familyNameUpdated => 'Family name updated';

  @override
  String get familyInviteCodeCopied => 'Invite code copied';

  @override
  String get familyLeaveAction => 'Leave family';

  @override
  String get familyTransferBeforeLeave =>
      'Transfer ownership before leaving the family.';

  @override
  String get familyEmptyTitle => 'No family connected';

  @override
  String get familyEmptyMessage =>
      'Create a family or join one with an invite code.';

  @override
  String get familyCreateTitle => 'Create a family';

  @override
  String get familyNameLabel => 'Family name';

  @override
  String get familyCreateAction => 'Create family';

  @override
  String get familyJoinTitle => 'Join with an invite';

  @override
  String get familyInviteCodeLabel => 'Invite code';

  @override
  String get familyJoinAction => 'Join family';

  @override
  String familyMembersInFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members in your family',
      one: '$count member in your family',
    );
    return '$_temp0';
  }

  @override
  String get familySaveNameAction => 'Save family name';

  @override
  String get familyInviteMembersTitle => 'Invite family members';

  @override
  String get familyInviteByEmailLabel => 'Invite by email';

  @override
  String get familySendEmailInvite => 'Send email invite';

  @override
  String get familyCreateInviteCode => 'Create invite code';

  @override
  String familyShareInviteCode(String code) {
    return 'Share this invite code: $code';
  }

  @override
  String get familyCopyInviteCode => 'Copy invite code';

  @override
  String get familyMembersTitle => 'Family members';

  @override
  String get familyNoMembersYet => 'No members yet';

  @override
  String familyMemberYou(String name) {
    return '$name (You)';
  }

  @override
  String get familyRoleOwner => 'Owner';

  @override
  String get familyRoleMember => 'Member';

  @override
  String get familyStatusActive => 'Active';

  @override
  String get familyStatusLeft => 'Left';

  @override
  String get familyTransferNeedAnotherMember =>
      'Add another active member before transferring ownership.';

  @override
  String get familyTransferOwnershipTitle => 'Transfer ownership';

  @override
  String get familyNewOwnerLabel => 'New owner';

  @override
  String get familyTransferOwnershipAction => 'Transfer ownership';

  @override
  String get privacyAnalyticsTitle => 'Share anonymous analytics';

  @override
  String get privacyAnalyticsSubtitle =>
      'Help improve the app with aggregated usage information.';

  @override
  String get privacyDeletionCancelled => 'Deletion request cancelled';

  @override
  String get privacyDeletionCompleted => 'Deletion completed.';

  @override
  String get privacyDataExportTitle => 'Data export';

  @override
  String get privacyDownloadExport => 'Download export';

  @override
  String get privacyAccountDeletionTitle => 'Account deletion';

  @override
  String get privacyNoRequestsTitle => 'No active privacy requests';

  @override
  String get privacyNoRequestsMessage =>
      'Request an export or account deletion when you need it.';

  @override
  String privacyAvailableUntil(String date) {
    return 'Available until $date.';
  }

  @override
  String get privacyExportExpiredMessage =>
      'Export expired. Request a new data export to generate a fresh link.';

  @override
  String get privacyExportFailedMessage =>
      'Export failed. Request a new data export to try again.';

  @override
  String get privacyPreparingExportMessage =>
      'Preparing export. We will make it available when it is ready.';

  @override
  String privacyPreparingExportRequestedOn(String date) {
    return 'Preparing export. Requested on $date.';
  }

  @override
  String privacyDeletionScheduledFor(String date) {
    return 'Deletion scheduled for $date.';
  }

  @override
  String get privacyDownloadDialogMessage =>
      'Use this secure link in your browser to download the export archive.';

  @override
  String get privacyDownloadLinkCopied => 'Download link copied';

  @override
  String get privacyCopyLink => 'Copy link';

  @override
  String get privacyYourDataTitle => 'Your data';

  @override
  String get privacyRequestExport => 'Request data export';

  @override
  String get privacyRequestDeletion => 'Request account deletion';

  @override
  String get privacyCancelDeletionRequest => 'Cancel deletion request';

  @override
  String get mediaTitle => 'Media & Avatars';

  @override
  String get mediaReload => 'Reload media';

  @override
  String get mediaUploadImage => 'Pick, crop and upload image';

  @override
  String mediaLastMediaId(String id) {
    return 'Last media id: $id';
  }

  @override
  String get mediaEmptyTitle => 'No media objects';

  @override
  String get mediaEmptyMessage => 'Upload an image to populate media history.';

  @override
  String mediaItemTitle(int id) {
    return 'Media #$id';
  }

  @override
  String get moneyGoalsSectionTitle => 'Goals';

  @override
  String moneyGoalsSidebarSummary(int activeCount, int archivedCount) {
    return '$activeCount active, $archivedCount archived';
  }

  @override
  String get moneyGoalsActiveSection => 'Active';

  @override
  String get moneyGoalsArchivedSection => 'Archive';

  @override
  String get moneyGoalsNoFamilyTitle => 'Choose a family first';

  @override
  String get moneyGoalsNoFamilyMessage =>
      'Goals are tied to the selected family. Open family settings to create or join one.';

  @override
  String get moneyGoalsOpenFamilySettings => 'Open family settings';

  @override
  String get moneyGoalsEmptyTitle => 'No goals yet';

  @override
  String get moneyGoalsEmptyMessage =>
      'Create your first goal from the detail pane.';

  @override
  String get moneyGoalsCreateFirstGoal => 'Create first goal';

  @override
  String get moneyGoalsStatusArchived => 'Archived';

  @override
  String get moneyGoalsStatusReached => 'Reached';

  @override
  String get moneyGoalsStatusActive => 'Active';

  @override
  String moneyGoalsRemainingChip(String amount) {
    return 'Remaining $amount';
  }

  @override
  String moneyGoalsDeadlineChip(String date) {
    return 'Deadline $date';
  }

  @override
  String get moneyGoalsCreateSheetTitle => 'Create a new goal';

  @override
  String get moneyGoalsCreateSheetSubtitle =>
      'Enter a title and the target amount in standard money format.';

  @override
  String get moneyGoalsTargetAmountLabel => 'Target amount';

  @override
  String get moneyGoalsCreateGoalAction => 'Create goal';

  @override
  String get moneyGoalsArchivedReadonlyMessage =>
      'Archived goals stay visible, but their settings can no longer be edited.';

  @override
  String get moneyGoalsAddContributionTitle => 'Add contribution';

  @override
  String moneyGoalsAddContributionDescription(String title) {
    return 'Top up \"$title\" with a one-time contribution.';
  }

  @override
  String get moneyGoalsContributionAmountLabel => 'Contribution amount';

  @override
  String get moneyGoalsAddContributionAction => 'Add contribution';

  @override
  String get moneyGoalsWithdrawTitle => 'Withdraw money';

  @override
  String moneyGoalsWithdrawDescription(String title) {
    return 'Take money back from \"$title\".';
  }

  @override
  String get moneyGoalsWithdrawAmountLabel => 'Withdraw amount';

  @override
  String get moneyGoalsWithdrawAction => 'Withdraw money';

  @override
  String get moneyGoalsGoalTitleLabel => 'Goal title';

  @override
  String get moneyGoalsGoalTitleHint => 'Emergency fund';

  @override
  String get moneyGoalsDeadlineLabel => 'Deadline';

  @override
  String get moneyGoalsDescriptionLabel => 'Description';

  @override
  String get moneyGoalsDescriptionHint => 'Optional note for the family';

  @override
  String get moneyGoalsRemainingLabel => 'Remaining';

  @override
  String get moneyGoalsCompleteAndArchive => 'Complete and archive';

  @override
  String get moneyGoalsNewGoal => 'New goal';

  @override
  String get moneyGoalsProgressTitle => 'Progress';

  @override
  String get moneyGoalsRecentActivityTitle => 'Recent activity';

  @override
  String get moneyGoalsNoHistoryYet => 'No contributions or withdrawals yet.';

  @override
  String get moneyGoalsGoalSettingsTitle => 'Goal settings';

  @override
  String get moneyGoalsArchiveGoalAction => 'Archive goal';

  @override
  String get moneyGoalsDeleteGoalAction => 'Delete goal';

  @override
  String get tasksLoading => 'Loading tasks...';

  @override
  String get calendarAddEvent => 'Add event';

  @override
  String get calendarLoading => 'Loading your calendar...';

  @override
  String get calendarCreateEventTitle => 'Create event';

  @override
  String get calendarSaveEvent => 'Save event';

  @override
  String get uiErrorFamilyNotSelected => 'Family is not selected.';

  @override
  String get uiErrorFamilyTaskNotSelected => 'Family or task is not selected.';

  @override
  String get uiErrorFamilyGoalNotSelected => 'Family or goal is not selected.';

  @override
  String get uiErrorArchivedGoalCannotBeEdited =>
      'Archived goals cannot be edited.';

  @override
  String get uiErrorFamilyNameEmpty => 'Family name cannot be empty.';

  @override
  String get uiErrorFamilyRenameQueued =>
      'Network unavailable. Family rename queued.';

  @override
  String get uiErrorFamilyTransferQueued =>
      'Network unavailable. Transfer request queued.';

  @override
  String get uiErrorFamilyLeaveQueued =>
      'Network unavailable. Leave request queued.';

  @override
  String get uiErrorPrivacyExportQueued =>
      'Network unavailable. Export request queued.';

  @override
  String get uiErrorPrivacyDeletionQueued =>
      'Network unavailable. Deletion request queued.';

  @override
  String get uiErrorMediaDeleteQueued =>
      'Network unavailable. Delete request queued.';

  @override
  String get uiErrorExportProcessing =>
      'Export is still processing. Check back in a moment.';

  @override
  String get commonClear => 'Clear';

  @override
  String get moneyGoalsLoading => 'Loading goals...';

  @override
  String get moneyGoalsEmptyDetailMessage =>
      'Create your first savings goal and start tracking progress.';

  @override
  String get moneyGoalsPickGoalTitle => 'Pick a goal';

  @override
  String get moneyGoalsPickGoalMessage =>
      'Select a goal from the active list or archive to inspect progress and actions.';

  @override
  String get moneyGoalsCreateAnotherGoal => 'Create another goal';

  @override
  String get moneyGoalsNoDeadlineSet => 'No deadline set';

  @override
  String get moneyGoalsPickDate => 'Pick date';

  @override
  String get moneyGoalsGoalTitleValidation => 'Enter a goal title';

  @override
  String get moneyGoalsAmountValidation => 'Enter a valid amount';

  @override
  String get taskEditorAssigneeLabel => 'Assignee';

  @override
  String get tasksSummaryOpen => 'Open';

  @override
  String get tasksSummaryDueToday => 'Due today';

  @override
  String get tasksSummaryOverdue => 'Overdue';

  @override
  String get tasksSummaryArchive => 'Archive';

  @override
  String get tasksEmptyArchiveTitle => 'Archive is empty';

  @override
  String get tasksEmptyArchiveMessage =>
      'Completed tasks will appear here once something is checked off.';

  @override
  String get tasksEmptyFilteredTitle => 'No tasks match this view';

  @override
  String get tasksEmptyFilteredMessage =>
      'Try another filter or create a new task to get things moving.';

  @override
  String tasksTaskCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '$count task',
    );
    return '$_temp0';
  }

  @override
  String get tasksPickTaskTitle => 'Pick a task';

  @override
  String get tasksPickTaskMessage =>
      'Select any task from the workspace to inspect details, reminders, and history.';

  @override
  String get tasksDetailCompletedItem => 'Completed item';

  @override
  String get tasksDetailOpenFamilyTask => 'Open family task';

  @override
  String get tasksMetaPersonal => 'Personal';

  @override
  String get tasksMetaShared => 'Shared';

  @override
  String get tasksActionComplete => 'Complete';

  @override
  String get tasksActionEdit => 'Edit';

  @override
  String get tasksActionDelete => 'Delete';

  @override
  String get tasksHistoryTitle => 'History';

  @override
  String get tasksNoHistoryTitle => 'No history yet';

  @override
  String get tasksNoHistoryMessage =>
      'Changes and completion activity will appear here.';

  @override
  String get tasksStatusCompleted => 'Completed';

  @override
  String get tasksStatusOpen => 'Open';

  @override
  String get tasksNoFamilyTitle => 'Choose a family first';

  @override
  String get tasksNoFamilyMessage =>
      'Tasks are tied to the selected family. Open family settings to create or join one.';

  @override
  String get tasksOpenFamilySettings => 'Open family settings';

  @override
  String get tasksSectionOverdue => 'Overdue';

  @override
  String get tasksSectionToday => 'Today';

  @override
  String get tasksSectionUpcoming => 'Upcoming';

  @override
  String get tasksSectionNoDueDate => 'No due date';

  @override
  String get tasksFilterAllOpen => 'All open';

  @override
  String get tasksFilterMine => 'Mine';

  @override
  String get tasksFilterUnassigned => 'Unassigned';

  @override
  String get tasksFilterDueSoon => 'Due soon';

  @override
  String get tasksFilterCompletedArchive => 'Completed archive';

  @override
  String get tasksHistoryCreated => 'Created';

  @override
  String get tasksHistoryUpdated => 'Updated';

  @override
  String get tasksHistoryCompleted => 'Completed';

  @override
  String tasksAssigneeMemberYou(String name) {
    return '$name (you)';
  }

  @override
  String get tasksAssigneeYou => 'You';

  @override
  String tasksAssigneeUser(int profileId) {
    return 'User $profileId';
  }

  @override
  String get tasksNoDueDate => 'No due date';

  @override
  String tasksDueChip(String date) {
    return 'Due $date';
  }

  @override
  String get tasksOfflineUnavailable => 'Tasks are unavailable while offline.';

  @override
  String get tasksDeleteTaskTitle => 'Delete task';

  @override
  String tasksDeleteTaskDescription(String title) {
    return 'Delete \"$title\" permanently from active tasks and archive.';
  }

  @override
  String get tasksDeleteTaskConfirm => 'Delete task';

  @override
  String get moneyGoalsSummaryTitle => 'Goals snapshot';

  @override
  String get moneyGoalsSummaryActiveGoals => 'Active goals';

  @override
  String get moneyGoalsSummaryArchived => 'Archived';

  @override
  String get moneyGoalsSummaryCompleted => 'Completed';

  @override
  String get moneyGoalsSummarySavedTotal => 'Saved total';

  @override
  String moneyGoalsGoalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '$count goal',
    );
    return '$_temp0';
  }

  @override
  String get moneyGoalsNoActiveGoalsMessage =>
      'No active goals right now. Archived goals stay below for reference.';

  @override
  String get moneyGoalsArchiveGoalConfirmTitle => 'Archive goal';

  @override
  String moneyGoalsArchiveGoalConfirmDescription(String title) {
    return 'Archive \"$title\"? It will stay visible, but editing will be locked.';
  }

  @override
  String get moneyGoalsDeleteGoalConfirmTitle => 'Delete goal';

  @override
  String moneyGoalsDeleteGoalConfirmDescription(String title) {
    return 'Delete \"$title\" permanently from active and archived goals.';
  }

  @override
  String moneyGoalsProgressOf(String current, String target) {
    return '$current of $target';
  }

  @override
  String moneyGoalsStatusArchivedOn(String date) {
    return 'Archived on $date';
  }

  @override
  String moneyGoalsStatusReachedOn(String date) {
    return 'Reached on $date';
  }

  @override
  String moneyGoalsStatusUpdatedAt(String date) {
    return 'Updated $date';
  }

  @override
  String moneyGoalsHistoryWithdrew(String name, String amount) {
    return '$name withdrew $amount';
  }

  @override
  String moneyGoalsHistoryAdded(String name, String amount) {
    return '$name added $amount';
  }

  @override
  String get calendarEditOccurrenceTitle => 'Edit occurrence';

  @override
  String get calendarEditFollowingTitle => 'Edit this and following';

  @override
  String get calendarEditWholeSeriesTitle => 'Edit whole series';

  @override
  String get calendarDeleteOccurrenceTitle => 'Delete occurrence';

  @override
  String get calendarDeleteOccurrenceMessage =>
      'Remove only this occurrence from the series?';

  @override
  String get calendarDeleteSeriesFutureMessage =>
      'Delete this and all following occurrences?';

  @override
  String get calendarDeleteSeriesAllMessage =>
      'Delete the entire recurring series?';

  @override
  String get calendarDeleteEventTitle => 'Delete event';

  @override
  String get calendarOfflineMessage =>
      'This action will sync when your connection returns.';

  @override
  String get calendarYourScheduleTitle => 'Your schedule';

  @override
  String get calendarUpdatingStatus => 'Updating';

  @override
  String get calendarRefreshingStatus => 'Refreshing';

  @override
  String get calendarSavingStatus => 'Saving';

  @override
  String get calendarFormatMonth => 'Month';

  @override
  String calendarPlansForDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plans for this day',
      one: '$count plan for this day',
    );
    return '$_temp0';
  }

  @override
  String get calendarOpenDayTitle => 'Open day';

  @override
  String calendarNextEventSummary(String timeRange, String title) {
    return 'Next: $timeRange • $title';
  }

  @override
  String get calendarOpenDayEmptyMessage =>
      'Nothing is scheduled yet. Add an event to keep the day organized.';

  @override
  String get calendarAgendaTitle => 'Day agenda';

  @override
  String calendarEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '$count event',
    );
    return '$_temp0';
  }

  @override
  String get calendarEmptyDayTitle => 'Nothing planned yet';

  @override
  String get calendarEmptyDayMessage =>
      'Create an event for this day and it will appear here with the right repeat and reminder settings.';

  @override
  String get calendarRepeatsChip => 'Repeats';

  @override
  String get calendarEditedChip => 'Edited';

  @override
  String get calendarReminderAtTime => 'At time';

  @override
  String get calendarReminderTenMinutesBefore => '10m before';

  @override
  String get calendarReminderOneHourBefore => '1h before';

  @override
  String get calendarReminderOneDayBefore => '1d before';

  @override
  String get calendarReminderGeneric => 'Reminder';

  @override
  String get calendarActionEditSection => 'Edit';

  @override
  String get calendarActionDeleteSection => 'Delete';

  @override
  String get calendarActionEditOccurrence => 'Edit this occurrence';

  @override
  String get calendarActionEditFollowing => 'Edit this and following';

  @override
  String get calendarActionEditWholeSeries => 'Edit whole series';

  @override
  String get calendarActionEditEvent => 'Edit event';

  @override
  String get calendarActionDeleteOccurrence => 'Delete this occurrence';

  @override
  String get calendarActionDeleteFollowing => 'Delete this and following';

  @override
  String get calendarActionDeleteWholeSeries => 'Delete whole series';

  @override
  String get calendarActionDeleteEvent => 'Delete event';

  @override
  String get calendarEditorRecurringSubtitle =>
      'Set time, reminders, and repeat rules in one place.';

  @override
  String get calendarEditorSingleSubtitle =>
      'Update this single occurrence without changing the full series.';

  @override
  String get calendarEditorBasicsTitle => 'Basics';

  @override
  String get calendarEditorBasicsSubtitle =>
      'A clear title helps the whole family scan the day faster.';

  @override
  String get calendarEditorTitleLabel => 'Event title';

  @override
  String get calendarEditorNotesLabel => 'Notes';

  @override
  String get calendarEditorOptionalHint => 'Optional';

  @override
  String get calendarEditorScheduleTitle => 'Schedule';

  @override
  String get calendarEditorScheduleSubtitle =>
      'Choose a polished start and end time for the event.';

  @override
  String get calendarEditorStartsLabel => 'Starts';

  @override
  String get calendarEditorEndsLabel => 'Ends';

  @override
  String get calendarEditorReminderTitle => 'Reminder';

  @override
  String get calendarEditorReminderSubtitle =>
      'Notifications should appear only when they are helpful.';

  @override
  String get calendarEditorRepeatTitle => 'Repeat';

  @override
  String get calendarEditorRepeatSubtitle =>
      'Keep repeat rules visible and only reveal the controls that matter.';

  @override
  String get calendarEditorDaysOfWeekLabel => 'Days of week';

  @override
  String get calendarEditorRepeatEveryDaysLabel => 'Repeat every N days';

  @override
  String get calendarEditorTitleValidation => 'Please add an event title.';

  @override
  String get calendarEditorEndAfterStartValidation =>
      'End time must be after the start time.';

  @override
  String get calendarEditorIntervalValidation =>
      'Repeat interval should be at least 1 day.';

  @override
  String get calendarRecurrenceNoneTitle => 'Does not repeat';

  @override
  String get calendarRecurrenceYearlyTitle => 'Every year on this day';

  @override
  String get calendarRecurrenceMonthlyTitle => 'Every month on this day';

  @override
  String get calendarRecurrenceWeeklyTitle => 'Selected weekdays';

  @override
  String get calendarRecurrenceEveryNDaysTitle => 'Every N days';

  @override
  String get calendarRecurrenceNoneSubtitle => 'One-time event.';

  @override
  String get calendarRecurrenceYearlySubtitle =>
      'Useful for birthdays and anniversaries.';

  @override
  String get calendarRecurrenceMonthlySubtitle =>
      'Runs on the same day number every month.';

  @override
  String get calendarRecurrenceWeeklySubtitle =>
      'Choose one or several weekdays.';

  @override
  String get calendarRecurrenceEveryNDaysSubtitle =>
      'Great for routines with a fixed interval.';

  @override
  String calendarDurationHours(int hours) {
    return '${hours}h';
  }

  @override
  String calendarDurationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String calendarDurationMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get calendarMutationScopeOne => 'This occurrence';

  @override
  String get calendarMutationScopeFuture => 'This and following';

  @override
  String get calendarMutationScopeAll => 'Whole series';
}
