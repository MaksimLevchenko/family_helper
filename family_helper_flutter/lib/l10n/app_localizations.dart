import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Family Helper'**
  String get appName;

  /// No description provided for @bootstrapUnableToStart.
  ///
  /// In en, this message translates to:
  /// **'Unable to start the app.'**
  String get bootstrapUnableToStart;

  /// No description provided for @bootstrapPreparingSpace.
  ///
  /// In en, this message translates to:
  /// **'Preparing your space...'**
  String get bootstrapPreparingSpace;

  /// No description provided for @notificationActionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationActionTooltip;

  /// No description provided for @serverUnavailableBanner.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Some actions may not work until connection is restored.'**
  String get serverUnavailableBanner;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSection;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfileTitle;

  /// No description provided for @settingsFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get settingsFamilyTitle;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how Family Helper picks the language for this device and your notifications.'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get settingsLanguageRussian;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @settingsCurrentMode.
  ///
  /// In en, this message translates to:
  /// **'Current mode: {mode}'**
  String settingsCurrentMode(String mode);

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsProfileSummaryLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get settingsProfileSummaryLoading;

  /// No description provided for @settingsProfileSummaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Update your name, timezone, and photo'**
  String get settingsProfileSummaryEmpty;

  /// No description provided for @settingsPhotoMissing.
  ///
  /// In en, this message translates to:
  /// **'No photo'**
  String get settingsPhotoMissing;

  /// No description provided for @settingsPhotoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get settingsPhotoAdded;

  /// No description provided for @settingsFamilySummaryNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get settingsFamilySummaryNotConnected;

  /// No description provided for @settingsFamilySummaryLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading family...'**
  String get settingsFamilySummaryLoading;

  /// No description provided for @settingsFamilySummaryConnected.
  ///
  /// In en, this message translates to:
  /// **'Family connected'**
  String get settingsFamilySummaryConnected;

  /// No description provided for @settingsMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} member} other{{count} members}}'**
  String settingsMemberCount(int count);

  /// No description provided for @settingsSwitchOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsSwitchOn;

  /// No description provided for @settingsSwitchOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsSwitchOff;

  /// No description provided for @settingsNotificationsSummary.
  ///
  /// In en, this message translates to:
  /// **'{permission} • Task {tasks} • Calendar {calendar}'**
  String settingsNotificationsSummary(
    String permission,
    String tasks,
    String calendar,
  );

  /// No description provided for @settingsAnalyticsOn.
  ///
  /// In en, this message translates to:
  /// **'Analytics on'**
  String get settingsAnalyticsOn;

  /// No description provided for @settingsAnalyticsOff.
  ///
  /// In en, this message translates to:
  /// **'Analytics off'**
  String get settingsAnalyticsOff;

  /// No description provided for @settingsDeletionScheduled.
  ///
  /// In en, this message translates to:
  /// **'Deletion scheduled'**
  String get settingsDeletionScheduled;

  /// No description provided for @settingsExportReady.
  ///
  /// In en, this message translates to:
  /// **'Export ready'**
  String get settingsExportReady;

  /// No description provided for @settingsExportExpired.
  ///
  /// In en, this message translates to:
  /// **'Export expired'**
  String get settingsExportExpired;

  /// No description provided for @settingsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get settingsExportFailed;

  /// No description provided for @settingsPreparingExport.
  ///
  /// In en, this message translates to:
  /// **'Preparing export'**
  String get settingsPreparingExport;

  /// No description provided for @settingsNoActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'No active requests'**
  String get settingsNoActiveRequests;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFoundTitle;

  /// No description provided for @profileNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in and refresh profile.'**
  String get profileNotFoundMessage;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayNameLabel;

  /// No description provided for @profileTimezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get profileTimezoneLabel;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get profileSave;

  /// No description provided for @profileNoPhotoYet.
  ///
  /// In en, this message translates to:
  /// **'No profile photo yet'**
  String get profileNoPhotoYet;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get profilePhoto;

  /// No description provided for @profilePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Use a clear photo so family members can recognize you easily.'**
  String get profilePhotoHint;

  /// No description provided for @profileAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get profileAddPhoto;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profileRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get profileRemovePhoto;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeNoFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Build a beautiful family dashboard'**
  String get homeNoFamilyTitle;

  /// No description provided for @homeNoFamilyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add or join a family to bring shared plans, tasks, shopping lists, and savings goals into one warm home base.'**
  String get homeNoFamilyMessage;

  /// No description provided for @homeFeatureSharedCalendar.
  ///
  /// In en, this message translates to:
  /// **'Shared calendar'**
  String get homeFeatureSharedCalendar;

  /// No description provided for @homeFeatureFamilyTasks.
  ///
  /// In en, this message translates to:
  /// **'Family tasks'**
  String get homeFeatureFamilyTasks;

  /// No description provided for @homeFeatureListsSync.
  ///
  /// In en, this message translates to:
  /// **'Lists that stay in sync'**
  String get homeFeatureListsSync;

  /// No description provided for @homeFeatureSavingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings goals together'**
  String get homeFeatureSavingsGoals;

  /// No description provided for @homeAddFamily.
  ///
  /// In en, this message translates to:
  /// **'Add family'**
  String get homeAddFamily;

  /// No description provided for @homeHeroFamilyFallback.
  ///
  /// In en, this message translates to:
  /// **'Your family'**
  String get homeHeroFamilyFallback;

  /// No description provided for @homeHeroSharedDashboard.
  ///
  /// In en, this message translates to:
  /// **'Shared dashboard'**
  String get homeHeroSharedDashboard;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything your family needs, at a glance.'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start here for the next event, the tasks that need attention, and the goals that are moving forward together.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get homeTasks;

  /// No description provided for @homeCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get homeCalendar;

  /// No description provided for @homeLists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get homeLists;

  /// No description provided for @homeGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get homeGoals;

  /// No description provided for @homeTasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Open tasks ready for focus'**
  String get homeTasksDescription;

  /// No description provided for @homeCalendarDescription.
  ///
  /// In en, this message translates to:
  /// **'Planned moments on the family timeline'**
  String get homeCalendarDescription;

  /// No description provided for @homeListsDescription.
  ///
  /// In en, this message translates to:
  /// **'Items still waiting to be checked off'**
  String get homeListsDescription;

  /// No description provided for @homeGoalsDescription.
  ///
  /// In en, this message translates to:
  /// **'Active savings journeys in motion'**
  String get homeGoalsDescription;

  /// No description provided for @homeComingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get homeComingUp;

  /// No description provided for @homeComingUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The next moments everyone is moving toward.'**
  String get homeComingUpSubtitle;

  /// No description provided for @homeNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get homeNeedsAttention;

  /// No description provided for @homeNeedsAttentionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick scan of the tasks most likely to matter next.'**
  String get homeNeedsAttentionSubtitle;

  /// No description provided for @homeNoUpcomingEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get homeNoUpcomingEventsTitle;

  /// No description provided for @homeNoUpcomingEventsMessage.
  ///
  /// In en, this message translates to:
  /// **'Your next family plans will show up here as soon as something lands on the calendar.'**
  String get homeNoUpcomingEventsMessage;

  /// No description provided for @homeNoUrgentTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing urgent right now'**
  String get homeNoUrgentTasksTitle;

  /// No description provided for @homeNoUrgentTasksMessage.
  ///
  /// In en, this message translates to:
  /// **'When new tasks need attention, they will appear here in priority order.'**
  String get homeNoUrgentTasksMessage;

  /// No description provided for @homeNotificationEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on top of family reminders'**
  String get homeNotificationEnableTitle;

  /// No description provided for @homeNotificationBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked'**
  String get homeNotificationBlockedTitle;

  /// No description provided for @homeQuickNavigation.
  ///
  /// In en, this message translates to:
  /// **'Quick navigation'**
  String get homeQuickNavigation;

  /// No description provided for @homeQuickNavigationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jump straight into the part of the household flow you want to move next.'**
  String get homeQuickNavigationSubtitle;

  /// No description provided for @homeSavingsSpotlight.
  ///
  /// In en, this message translates to:
  /// **'Savings spotlight'**
  String get homeSavingsSpotlight;

  /// No description provided for @homeNoGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'No active goals yet'**
  String get homeNoGoalsTitle;

  /// No description provided for @homeNoGoalsMessage.
  ///
  /// In en, this message translates to:
  /// **'Start a savings goal to keep the family’s next milestone visible every day.'**
  String get homeNoGoalsMessage;

  /// No description provided for @homeGoalLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String homeGoalLeft(String amount);

  /// No description provided for @homeDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline {date}'**
  String homeDeadline(String date);

  /// No description provided for @homeOpenGoals.
  ///
  /// In en, this message translates to:
  /// **'Open goals'**
  String get homeOpenGoals;

  /// No description provided for @homeListsSpotlight.
  ///
  /// In en, this message translates to:
  /// **'Lists spotlight'**
  String get homeListsSpotlight;

  /// No description provided for @homeNoListsTitle.
  ///
  /// In en, this message translates to:
  /// **'No active lists'**
  String get homeNoListsTitle;

  /// No description provided for @homeNoListsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a shopping or chore list and it will become part of the dashboard rhythm here.'**
  String get homeNoListsMessage;

  /// No description provided for @homeListItemsOpen.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item open} other{{count} items open}}'**
  String homeListItemsOpen(int count);

  /// No description provided for @homeListEverythingDone.
  ///
  /// In en, this message translates to:
  /// **'Everything here is already wrapped up.'**
  String get homeListEverythingDone;

  /// No description provided for @homeListMomentum.
  ///
  /// In en, this message translates to:
  /// **'A quick place to continue the list that still has the most momentum.'**
  String get homeListMomentum;

  /// No description provided for @homeOpenLists.
  ///
  /// In en, this message translates to:
  /// **'Open lists'**
  String get homeOpenLists;

  /// No description provided for @homeTaskUrgencyNoDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get homeTaskUrgencyNoDate;

  /// No description provided for @homeTaskUrgencyOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get homeTaskUrgencyOverdue;

  /// No description provided for @homeTaskUrgencyToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get homeTaskUrgencyToday;

  /// No description provided for @homeTaskUrgencyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get homeTaskUrgencyUpcoming;

  /// No description provided for @homeTaskDueHint.
  ///
  /// In en, this message translates to:
  /// **'Add a due date to prioritize it'**
  String get homeTaskDueHint;

  /// No description provided for @listTypeShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get listTypeShopping;

  /// No description provided for @listTypeTodo.
  ///
  /// In en, this message translates to:
  /// **'To-do'**
  String get listTypeTodo;

  /// No description provided for @notificationsSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationsSettingsTitle;

  /// No description provided for @notificationsTuneTitle.
  ///
  /// In en, this message translates to:
  /// **'Tune how Family Helper reaches you'**
  String get notificationsTuneTitle;

  /// No description provided for @notificationsTuneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which reminders stay active on this device and keep permission status in a healthy state.'**
  String get notificationsTuneSubtitle;

  /// No description provided for @notificationsSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System notifications'**
  String get notificationsSystemTitle;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDebugTitle.
  ///
  /// In en, this message translates to:
  /// **'Debug tools'**
  String get notificationsDebugTitle;

  /// No description provided for @notificationsDebugSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sends a real Firebase push through the server to this signed-in device.'**
  String get notificationsDebugSubtitle;

  /// No description provided for @notificationsSendTestPush.
  ///
  /// In en, this message translates to:
  /// **'Send test push'**
  String get notificationsSendTestPush;

  /// No description provided for @notificationsTaskReminders.
  ///
  /// In en, this message translates to:
  /// **'Task reminders'**
  String get notificationsTaskReminders;

  /// No description provided for @notificationsTaskRemindersOn.
  ///
  /// In en, this message translates to:
  /// **'You will receive reminders for upcoming tasks.'**
  String get notificationsTaskRemindersOn;

  /// No description provided for @notificationsTaskRemindersOff.
  ///
  /// In en, this message translates to:
  /// **'Task reminders are currently turned off.'**
  String get notificationsTaskRemindersOff;

  /// No description provided for @notificationsTaskRemindersNeedsPermission.
  ///
  /// In en, this message translates to:
  /// **'Turn on device notifications to receive task reminders.'**
  String get notificationsTaskRemindersNeedsPermission;

  /// No description provided for @notificationsCalendarReminders.
  ///
  /// In en, this message translates to:
  /// **'Calendar reminders'**
  String get notificationsCalendarReminders;

  /// No description provided for @notificationsCalendarRemindersOn.
  ///
  /// In en, this message translates to:
  /// **'You will receive reminders for upcoming events.'**
  String get notificationsCalendarRemindersOn;

  /// No description provided for @notificationsCalendarRemindersOff.
  ///
  /// In en, this message translates to:
  /// **'Calendar reminders are currently turned off.'**
  String get notificationsCalendarRemindersOff;

  /// No description provided for @notificationsCalendarRemindersNeedsPermission.
  ///
  /// In en, this message translates to:
  /// **'Turn on device notifications to receive calendar reminders.'**
  String get notificationsCalendarRemindersNeedsPermission;

  /// No description provided for @notificationsCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsCenterTitle;

  /// No description provided for @notificationsBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get notificationsBackToHome;

  /// No description provided for @notificationChannelReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationChannelReminders;

  /// No description provided for @notificationChannelFamily.
  ///
  /// In en, this message translates to:
  /// **'Family notifications'**
  String get notificationChannelFamily;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Rich reminders and family updates from Family Helper'**
  String get notificationChannelDescription;

  /// No description provided for @notificationsSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationsSettingsTooltip;

  /// No description provided for @notificationsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading notifications...'**
  String get notificationsLoading;

  /// No description provided for @notificationsConnectFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect a family to start receiving updates'**
  String get notificationsConnectFamilyTitle;

  /// No description provided for @notificationsConnectFamilyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your dedicated notification center will light up with reminders, invites, and activity once you join a family.'**
  String get notificationsConnectFamilyMessage;

  /// No description provided for @notificationsOpenFamilySettings.
  ///
  /// In en, this message translates to:
  /// **'Open family settings'**
  String get notificationsOpenFamilySettings;

  /// No description provided for @notificationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsFilterAll;

  /// No description provided for @notificationsFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsFilterUnread;

  /// No description provided for @notificationsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Family inbox'**
  String get notificationsHeroTitle;

  /// No description provided for @notificationsHeroUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String notificationsHeroUnread(int count);

  /// No description provided for @notificationsHeroAllRead.
  ///
  /// In en, this message translates to:
  /// **'Everything is read'**
  String get notificationsHeroAllRead;

  /// No description provided for @notificationsHeroReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for new updates'**
  String get notificationsHeroReady;

  /// No description provided for @notificationsHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A dedicated place for reminders, updates, and family activity that deserves attention.'**
  String get notificationsHeroSubtitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsNoUnreadTitle.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get notificationsNoUnreadTitle;

  /// No description provided for @notificationsNoUnreadMessage.
  ///
  /// In en, this message translates to:
  /// **'Everything in your family inbox has already been opened.'**
  String get notificationsNoUnreadMessage;

  /// No description provided for @notificationsNoItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsNoItemsTitle;

  /// No description provided for @notificationsNoItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'New reminders and family activity will show up here as soon as they arrive.'**
  String get notificationsNoItemsMessage;

  /// No description provided for @notificationsShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all notifications'**
  String get notificationsShowAll;

  /// No description provided for @notificationsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get notificationsLoadMore;

  /// No description provided for @notificationsDetailSelect.
  ///
  /// In en, this message translates to:
  /// **'Select a notification'**
  String get notificationsDetailSelect;

  /// No description provided for @notificationsDetailSelectMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose any update from the inbox to see the full message and related action.'**
  String get notificationsDetailSelectMessage;

  /// No description provided for @notificationsDetailPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your notification details will appear here'**
  String get notificationsDetailPlaceholderTitle;

  /// No description provided for @notificationsDetailPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Once new reminders or family activity arrive, you will be able to review the full context here.'**
  String get notificationsDetailPlaceholderMessage;

  /// No description provided for @notificationsRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get notificationsRead;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsUnread;

  /// No description provided for @notificationsDetailNoTarget.
  ///
  /// In en, this message translates to:
  /// **'This update does not include a linked destination, but the full message is preserved here for reference.'**
  String get notificationsDetailNoTarget;

  /// No description provided for @notificationCategoryReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get notificationCategoryReminder;

  /// No description provided for @notificationCategoryTaskAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned task'**
  String get notificationCategoryTaskAssigned;

  /// No description provided for @notificationCategoryTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed task'**
  String get notificationCategoryTaskCompleted;

  /// No description provided for @notificationCategoryCalendarUpdate.
  ///
  /// In en, this message translates to:
  /// **'Calendar update'**
  String get notificationCategoryCalendarUpdate;

  /// No description provided for @notificationCategoryCalendarCancelled.
  ///
  /// In en, this message translates to:
  /// **'Calendar cancelled'**
  String get notificationCategoryCalendarCancelled;

  /// No description provided for @notificationCategoryFamilyInvite.
  ///
  /// In en, this message translates to:
  /// **'Family invite'**
  String get notificationCategoryFamilyInvite;

  /// No description provided for @notificationCategoryFamilyUpdate.
  ///
  /// In en, this message translates to:
  /// **'Family update'**
  String get notificationCategoryFamilyUpdate;

  /// No description provided for @notificationCategoryTestPush.
  ///
  /// In en, this message translates to:
  /// **'Test push'**
  String get notificationCategoryTestPush;

  /// No description provided for @notificationCategoryGeneric.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationCategoryGeneric;

  /// No description provided for @notificationOpenTask.
  ///
  /// In en, this message translates to:
  /// **'Open task'**
  String get notificationOpenTask;

  /// No description provided for @notificationOpenCalendar.
  ///
  /// In en, this message translates to:
  /// **'Open calendar'**
  String get notificationOpenCalendar;

  /// No description provided for @notificationOpenList.
  ///
  /// In en, this message translates to:
  /// **'Open list'**
  String get notificationOpenList;

  /// No description provided for @notificationOpenGoal.
  ///
  /// In en, this message translates to:
  /// **'Open goal'**
  String get notificationOpenGoal;

  /// No description provided for @notificationOpenNotification.
  ///
  /// In en, this message translates to:
  /// **'Open notification'**
  String get notificationOpenNotification;

  /// No description provided for @notificationPermissionNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'Not set up'**
  String get notificationPermissionNotSetUp;

  /// No description provided for @notificationPermissionAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get notificationPermissionAllowed;

  /// No description provided for @notificationPermissionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get notificationPermissionBlocked;

  /// No description provided for @notificationPermissionBlockedInSettings.
  ///
  /// In en, this message translates to:
  /// **'Blocked in settings'**
  String get notificationPermissionBlockedInSettings;

  /// No description provided for @notificationPermissionAllowAction.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get notificationPermissionAllowAction;

  /// No description provided for @notificationPermissionEnabledAction.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationPermissionEnabledAction;

  /// No description provided for @notificationPermissionOpenSettingsAction.
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get notificationPermissionOpenSettingsAction;

  /// No description provided for @notificationPermissionNotSetUpDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications so Family Helper can remind you about tasks and events.'**
  String get notificationPermissionNotSetUpDescription;

  /// No description provided for @notificationPermissionAllowedDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications are enabled for this device.'**
  String get notificationPermissionAllowedDescription;

  /// No description provided for @notificationPermissionBlockedDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications were denied. Open system settings to allow them.'**
  String get notificationPermissionBlockedDescription;

  /// No description provided for @notificationPermissionBlockedInSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled in system settings. Re-enable them there to get reminders.'**
  String get notificationPermissionBlockedInSettingsDescription;

  /// No description provided for @notificationPresetNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get notificationPresetNone;

  /// No description provided for @notificationPresetAtTime.
  ///
  /// In en, this message translates to:
  /// **'At time'**
  String get notificationPresetAtTime;

  /// No description provided for @notificationPresetTenMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'10 minutes before'**
  String get notificationPresetTenMinutesBefore;

  /// No description provided for @notificationPresetOneHourBefore.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get notificationPresetOneHourBefore;

  /// No description provided for @notificationPresetOneDayBefore.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get notificationPresetOneDayBefore;

  /// No description provided for @notificationFamilyNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Family is not selected.'**
  String get notificationFamilyNotSelected;

  /// No description provided for @notificationReminderQueued.
  ///
  /// In en, this message translates to:
  /// **'Reminder will sync when your connection returns.'**
  String get notificationReminderQueued;

  /// No description provided for @notificationSaveReminderFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to save the reminder.'**
  String get notificationSaveReminderFailed;

  /// No description provided for @notificationAllowReminderPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications to receive reminders on this device.'**
  String get notificationAllowReminderPermission;

  /// No description provided for @notificationBlockedReminderPermission.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked. Open system settings to enable reminders.'**
  String get notificationBlockedReminderPermission;

  /// No description provided for @notificationDisabledReminderPermission.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled in system settings. Re-enable them there to get reminders.'**
  String get notificationDisabledReminderPermission;

  /// No description provided for @notificationEnableReminderFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to enable reminders right now. Please try again.'**
  String get notificationEnableReminderFailed;

  /// No description provided for @notificationReminderRemoved.
  ///
  /// In en, this message translates to:
  /// **'Reminder removed.'**
  String get notificationReminderRemoved;

  /// No description provided for @notificationUpdateReminderFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update the reminder.'**
  String get notificationUpdateReminderFailed;

  /// No description provided for @notificationDebugOnly.
  ///
  /// In en, this message translates to:
  /// **'Test pushes are only available in debug builds.'**
  String get notificationDebugOnly;

  /// No description provided for @notificationAllowTestPush.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications to receive the test push.'**
  String get notificationAllowTestPush;

  /// No description provided for @notificationBlockedTestPush.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked. Open system settings to run the push test.'**
  String get notificationBlockedTestPush;

  /// No description provided for @notificationDisabledTestPush.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled in system settings. Re-enable them there to run the push test.'**
  String get notificationDisabledTestPush;

  /// No description provided for @notificationSelectFamilyForTestPush.
  ///
  /// In en, this message translates to:
  /// **'Select a family before sending a test push.'**
  String get notificationSelectFamilyForTestPush;

  /// No description provided for @notificationTestPushSent.
  ///
  /// In en, this message translates to:
  /// **'Test push sent. It should arrive shortly.'**
  String get notificationTestPushSent;

  /// No description provided for @notificationTestPushSkipped.
  ///
  /// In en, this message translates to:
  /// **'Test push was created, but nothing was sent. Check token registration and Firebase server config.'**
  String get notificationTestPushSkipped;

  /// No description provided for @notificationTestPushFailed.
  ///
  /// In en, this message translates to:
  /// **'Test push dispatch failed. Check server logs and Firebase configuration.'**
  String get notificationTestPushFailed;

  /// No description provided for @notificationTestPushRequested.
  ///
  /// In en, this message translates to:
  /// **'Test push requested.'**
  String get notificationTestPushRequested;

  /// No description provided for @notificationSendTestPushFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to send the test push.'**
  String get notificationSendTestPushFailed;

  /// No description provided for @notificationPreferenceQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Preference change queued.'**
  String get notificationPreferenceQueued;

  /// No description provided for @notificationPushTokenQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Push token registration queued.'**
  String get notificationPushTokenQueued;

  /// No description provided for @notificationSubtitleReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get notificationSubtitleReminder;

  /// No description provided for @notificationSubtitleTaskReminder.
  ///
  /// In en, this message translates to:
  /// **'Task reminder'**
  String get notificationSubtitleTaskReminder;

  /// No description provided for @notificationSubtitleCalendarReminder.
  ///
  /// In en, this message translates to:
  /// **'Calendar reminder'**
  String get notificationSubtitleCalendarReminder;

  /// No description provided for @notificationSubtitleGoalReminder.
  ///
  /// In en, this message translates to:
  /// **'Goal reminder'**
  String get notificationSubtitleGoalReminder;

  /// No description provided for @notificationSubtitleListReminder.
  ///
  /// In en, this message translates to:
  /// **'List reminder'**
  String get notificationSubtitleListReminder;

  /// No description provided for @notificationSubtitleTaskUpdate.
  ///
  /// In en, this message translates to:
  /// **'Task update'**
  String get notificationSubtitleTaskUpdate;

  /// No description provided for @notificationSubtitleCalendarUpdate.
  ///
  /// In en, this message translates to:
  /// **'Calendar update'**
  String get notificationSubtitleCalendarUpdate;

  /// No description provided for @notificationSubtitleGoalUpdate.
  ///
  /// In en, this message translates to:
  /// **'Goal update'**
  String get notificationSubtitleGoalUpdate;

  /// No description provided for @notificationSubtitleListUpdate.
  ///
  /// In en, this message translates to:
  /// **'List update'**
  String get notificationSubtitleListUpdate;

  /// No description provided for @notificationSubtitleFamilyUpdate.
  ///
  /// In en, this message translates to:
  /// **'Family update'**
  String get notificationSubtitleFamilyUpdate;

  /// No description provided for @notificationSubtitleFamilyNotification.
  ///
  /// In en, this message translates to:
  /// **'Family notification'**
  String get notificationSubtitleFamilyNotification;

  /// No description provided for @commonEventReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Event reminder'**
  String get commonEventReminderTitle;

  /// No description provided for @commonEventReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Family event'**
  String get commonEventReminderBody;

  /// No description provided for @commonTaskReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Task reminder'**
  String get commonTaskReminderTitle;

  /// No description provided for @taskPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get taskPriorityLow;

  /// No description provided for @taskPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get taskPriorityNormal;

  /// No description provided for @taskPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get taskPriorityHigh;

  /// No description provided for @taskRepeatNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get taskRepeatNone;

  /// No description provided for @taskRepeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get taskRepeatDaily;

  /// No description provided for @taskRepeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get taskRepeatWeekly;

  /// No description provided for @taskRepeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get taskRepeatMonthly;

  /// No description provided for @taskDeadlineModeNone.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get taskDeadlineModeNone;

  /// No description provided for @taskDeadlineModeSpecificDate.
  ///
  /// In en, this message translates to:
  /// **'Specific date'**
  String get taskDeadlineModeSpecificDate;

  /// No description provided for @taskDeadlineModeIn.
  ///
  /// In en, this message translates to:
  /// **'In...'**
  String get taskDeadlineModeIn;

  /// No description provided for @taskOffsetUnitMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get taskOffsetUnitMinutes;

  /// No description provided for @taskOffsetUnitHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get taskOffsetUnitHours;

  /// No description provided for @taskOffsetUnitDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get taskOffsetUnitDays;

  /// No description provided for @taskEditorCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get taskEditorCreateTitle;

  /// No description provided for @taskEditorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskEditorEditTitle;

  /// No description provided for @taskEditorCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a family task with an optional deadline, recurrence, and reminders.'**
  String get taskEditorCreateSubtitle;

  /// No description provided for @taskEditorEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update assignment, deadline, recurrence, and reminder settings.'**
  String get taskEditorEditSubtitle;

  /// No description provided for @taskEditorTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskEditorTitleLabel;

  /// No description provided for @taskEditorTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Prepare the weekly grocery list'**
  String get taskEditorTitleHint;

  /// No description provided for @taskEditorTitleValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a task title.'**
  String get taskEditorTitleValidation;

  /// No description provided for @taskEditorDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get taskEditorDescriptionLabel;

  /// No description provided for @taskEditorDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional note for the family'**
  String get taskEditorDescriptionHint;

  /// No description provided for @taskEditorPersonalTaskLabel.
  ///
  /// In en, this message translates to:
  /// **'Personal task'**
  String get taskEditorPersonalTaskLabel;

  /// No description provided for @taskEditorPersonalTaskOn.
  ///
  /// In en, this message translates to:
  /// **'Only you will see this task.'**
  String get taskEditorPersonalTaskOn;

  /// No description provided for @taskEditorPersonalTaskOff.
  ///
  /// In en, this message translates to:
  /// **'Shared tasks stay visible to the whole family.'**
  String get taskEditorPersonalTaskOff;

  /// No description provided for @taskEditorPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskEditorPriorityLabel;

  /// No description provided for @taskEditorUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get taskEditorUnassigned;

  /// No description provided for @taskEditorDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get taskEditorDeadlineLabel;

  /// No description provided for @taskEditorNoDeadlineDescription.
  ///
  /// In en, this message translates to:
  /// **'This task will not have a deadline.'**
  String get taskEditorNoDeadlineDescription;

  /// No description provided for @taskEditorDueAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Due at'**
  String get taskEditorDueAtLabel;

  /// No description provided for @taskEditorAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get taskEditorAmountLabel;

  /// No description provided for @taskEditorAmountHint.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get taskEditorAmountHint;

  /// No description provided for @taskEditorPositiveNumberValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number.'**
  String get taskEditorPositiveNumberValidation;

  /// No description provided for @taskEditorUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get taskEditorUnitLabel;

  /// No description provided for @taskEditorDeadlinePreviewInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid offset to calculate the deadline.'**
  String get taskEditorDeadlinePreviewInvalid;

  /// No description provided for @taskEditorDeadlinePreview.
  ///
  /// In en, this message translates to:
  /// **'Will be due {date}'**
  String taskEditorDeadlinePreview(String date);

  /// No description provided for @taskEditorReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get taskEditorReminderLabel;

  /// No description provided for @taskEditorRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get taskEditorRepeatLabel;

  /// No description provided for @taskEditorIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get taskEditorIntervalLabel;

  /// No description provided for @taskEditorSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get taskEditorSaveChanges;

  /// No description provided for @taskEditorCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get taskEditorCreateAction;

  /// No description provided for @taskEditorDeadlineMissingMessage.
  ///
  /// In en, this message translates to:
  /// **'Pick a deadline date and time or switch to no deadline.'**
  String get taskEditorDeadlineMissingMessage;

  /// No description provided for @taskEditorDeadlineRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Set a due date before adding reminders or recurrence.'**
  String get taskEditorDeadlineRequiredMessage;

  /// No description provided for @taskEditorRelativePresetThirtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get taskEditorRelativePresetThirtyMinutes;

  /// No description provided for @taskEditorRelativePresetOneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get taskEditorRelativePresetOneHour;

  /// No description provided for @taskEditorRelativePresetThreeHours.
  ///
  /// In en, this message translates to:
  /// **'3 hours'**
  String get taskEditorRelativePresetThreeHours;

  /// No description provided for @taskEditorRelativePresetOneDay.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get taskEditorRelativePresetOneDay;

  /// No description provided for @taskEditorRelativePresetThreeDays.
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get taskEditorRelativePresetThreeDays;

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get commonSaveChanges;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get commonNote;

  /// No description provided for @commonJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get commonJustNow;

  /// No description provided for @commonShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get commonShowMore;

  /// No description provided for @commonShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get commonShowLess;

  /// No description provided for @commonOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get commonOverview;

  /// No description provided for @commonHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get commonHistory;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @listsFamilyFallback.
  ///
  /// In en, this message translates to:
  /// **'Family collaboration'**
  String get listsFamilyFallback;

  /// No description provided for @listsYourListsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your lists'**
  String get listsYourListsTitle;

  /// No description provided for @listsYourListsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a list and keep every check-off visible.'**
  String get listsYourListsSubtitle;

  /// No description provided for @listsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No lists yet'**
  String get listsEmptyTitle;

  /// No description provided for @listsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Start with a shopping list or wishlist for your family.'**
  String get listsEmptyMessage;

  /// No description provided for @listsCreateFirstList.
  ///
  /// In en, this message translates to:
  /// **'Create your first list'**
  String get listsCreateFirstList;

  /// No description provided for @listsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'List details'**
  String get listsDetailsTitle;

  /// No description provided for @listsDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose or create a list to start adding items.'**
  String get listsDetailsSubtitle;

  /// No description provided for @listsListActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'List actions'**
  String get listsListActionsTooltip;

  /// No description provided for @listsEditListAction.
  ///
  /// In en, this message translates to:
  /// **'Edit list'**
  String get listsEditListAction;

  /// No description provided for @listsDeleteListAction.
  ///
  /// In en, this message translates to:
  /// **'Delete list'**
  String get listsDeleteListAction;

  /// No description provided for @listsNoSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'No list selected'**
  String get listsNoSelectionTitle;

  /// No description provided for @listsNoSelectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first list to start planning together.'**
  String get listsNoSelectionMessage;

  /// No description provided for @listsCreateSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new list'**
  String get listsCreateSheetTitle;

  /// No description provided for @listsEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit list'**
  String get listsEditSheetTitle;

  /// No description provided for @listsCreateListAction.
  ///
  /// In en, this message translates to:
  /// **'Create list'**
  String get listsCreateListAction;

  /// No description provided for @listsAddItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get listsAddItemTitle;

  /// No description provided for @listsEditItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get listsEditItemTitle;

  /// No description provided for @listsAddToListAction.
  ///
  /// In en, this message translates to:
  /// **'Add to list'**
  String get listsAddToListAction;

  /// No description provided for @listsDeleteListTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete list?'**
  String get listsDeleteListTitle;

  /// No description provided for @listsDeleteListMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove {title} and all of its items.'**
  String listsDeleteListMessage(String title);

  /// No description provided for @listsDeleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete item?'**
  String get listsDeleteItemTitle;

  /// No description provided for @listsDeleteItemMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove {title} from this list?'**
  String listsDeleteItemMessage(String title);

  /// No description provided for @listsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared lists that feel alive.'**
  String get listsHeroTitle;

  /// No description provided for @listsHeroEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first shopping or wishlist board and keep every check-off visible.'**
  String get listsHeroEmptyMessage;

  /// No description provided for @listsHeroCountMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} active list with clear ownership.} other{{count} active lists with clear ownership.}}'**
  String listsHeroCountMessage(int count);

  /// No description provided for @listsNewList.
  ///
  /// In en, this message translates to:
  /// **'New list'**
  String get listsNewList;

  /// No description provided for @listsMetricOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get listsMetricOpen;

  /// No description provided for @listsMetricUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get listsMetricUpdated;

  /// No description provided for @listsStartFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Start with your first item'**
  String get listsStartFirstItem;

  /// No description provided for @listsItemsStillOpen.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item still open} other{{count} items still open}}'**
  String listsItemsStillOpen(int count);

  /// No description provided for @listsReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'This list is ready'**
  String get listsReadyTitle;

  /// No description provided for @listsReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the first item to {title} and make it visible to everyone.'**
  String listsReadyMessage(String title);

  /// No description provided for @listsAddFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Add first item'**
  String get listsAddFirstItem;

  /// No description provided for @listsMarkedBy.
  ///
  /// In en, this message translates to:
  /// **'Marked by {name} - {time}'**
  String listsMarkedBy(String name, String time);

  /// No description provided for @listsItemActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Item actions'**
  String get listsItemActionsTooltip;

  /// No description provided for @listsEditItemAction.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get listsEditItemAction;

  /// No description provided for @listsDeleteItemAction.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get listsDeleteItemAction;

  /// No description provided for @listsCreateSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a template and make it easy for the whole family to follow.'**
  String get listsCreateSheetSubtitle;

  /// No description provided for @listsListTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'List title'**
  String get listsListTitleLabel;

  /// No description provided for @listsListTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Saturday groceries'**
  String get listsListTitleHint;

  /// No description provided for @listsAddItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything added here will show up in {title}.'**
  String listsAddItemSubtitle(String title);

  /// No description provided for @listsItemTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Item title'**
  String get listsItemTitleLabel;

  /// No description provided for @listsItemTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get listsItemTitleHint;

  /// No description provided for @listsQtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get listsQtyLabel;

  /// No description provided for @listsUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get listsUnitLabel;

  /// No description provided for @listsUnitHint.
  ///
  /// In en, this message translates to:
  /// **'pcs / kg'**
  String get listsUnitHint;

  /// No description provided for @listsNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Semi-skimmed if available'**
  String get listsNoteHint;

  /// No description provided for @listsPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get listsPriceLabel;

  /// No description provided for @listsTypeWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get listsTypeWishlist;

  /// No description provided for @listsSelectedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} open item} other{{count} open items}} - updated {time}'**
  String listsSelectedSubtitle(int count, String time);

  /// No description provided for @familyNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Family name updated'**
  String get familyNameUpdated;

  /// No description provided for @familyInviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied'**
  String get familyInviteCodeCopied;

  /// No description provided for @familyLeaveAction.
  ///
  /// In en, this message translates to:
  /// **'Leave family'**
  String get familyLeaveAction;

  /// No description provided for @familyTransferBeforeLeave.
  ///
  /// In en, this message translates to:
  /// **'Transfer ownership before leaving the family.'**
  String get familyTransferBeforeLeave;

  /// No description provided for @familyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No family connected'**
  String get familyEmptyTitle;

  /// No description provided for @familyEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a family or join one with an invite code.'**
  String get familyEmptyMessage;

  /// No description provided for @familyCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a family'**
  String get familyCreateTitle;

  /// No description provided for @familyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get familyNameLabel;

  /// No description provided for @familyCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create family'**
  String get familyCreateAction;

  /// No description provided for @familyJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join with an invite'**
  String get familyJoinTitle;

  /// No description provided for @familyInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get familyInviteCodeLabel;

  /// No description provided for @familyJoinAction.
  ///
  /// In en, this message translates to:
  /// **'Join family'**
  String get familyJoinAction;

  /// No description provided for @familyMembersInFamily.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} member in your family} other{{count} members in your family}}'**
  String familyMembersInFamily(int count);

  /// No description provided for @familySaveNameAction.
  ///
  /// In en, this message translates to:
  /// **'Save family name'**
  String get familySaveNameAction;

  /// No description provided for @familyInviteMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite family members'**
  String get familyInviteMembersTitle;

  /// No description provided for @familyInviteByEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite by email'**
  String get familyInviteByEmailLabel;

  /// No description provided for @familySendEmailInvite.
  ///
  /// In en, this message translates to:
  /// **'Send email invite'**
  String get familySendEmailInvite;

  /// No description provided for @familyCreateInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Create invite code'**
  String get familyCreateInviteCode;

  /// No description provided for @familyShareInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Share this invite code: {code}'**
  String familyShareInviteCode(String code);

  /// No description provided for @familyCopyInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Copy invite code'**
  String get familyCopyInviteCode;

  /// No description provided for @familyMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get familyMembersTitle;

  /// No description provided for @familyNoMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get familyNoMembersYet;

  /// No description provided for @familyMemberYou.
  ///
  /// In en, this message translates to:
  /// **'{name} (You)'**
  String familyMemberYou(String name);

  /// No description provided for @familyRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get familyRoleOwner;

  /// No description provided for @familyRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get familyRoleMember;

  /// No description provided for @familyStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get familyStatusActive;

  /// No description provided for @familyStatusLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get familyStatusLeft;

  /// No description provided for @familyTransferNeedAnotherMember.
  ///
  /// In en, this message translates to:
  /// **'Add another active member before transferring ownership.'**
  String get familyTransferNeedAnotherMember;

  /// No description provided for @familyTransferOwnershipTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer ownership'**
  String get familyTransferOwnershipTitle;

  /// No description provided for @familyNewOwnerLabel.
  ///
  /// In en, this message translates to:
  /// **'New owner'**
  String get familyNewOwnerLabel;

  /// No description provided for @familyTransferOwnershipAction.
  ///
  /// In en, this message translates to:
  /// **'Transfer ownership'**
  String get familyTransferOwnershipAction;

  /// No description provided for @privacyAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Share anonymous analytics'**
  String get privacyAnalyticsTitle;

  /// No description provided for @privacyAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help improve the app with aggregated usage information.'**
  String get privacyAnalyticsSubtitle;

  /// No description provided for @privacyDeletionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Deletion request cancelled'**
  String get privacyDeletionCancelled;

  /// No description provided for @privacyDeletionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Deletion completed.'**
  String get privacyDeletionCompleted;

  /// No description provided for @privacyDataExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Data export'**
  String get privacyDataExportTitle;

  /// No description provided for @privacyDownloadExport.
  ///
  /// In en, this message translates to:
  /// **'Download export'**
  String get privacyDownloadExport;

  /// No description provided for @privacyAccountDeletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account deletion'**
  String get privacyAccountDeletionTitle;

  /// No description provided for @privacyNoRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'No active privacy requests'**
  String get privacyNoRequestsTitle;

  /// No description provided for @privacyNoRequestsMessage.
  ///
  /// In en, this message translates to:
  /// **'Request an export or account deletion when you need it.'**
  String get privacyNoRequestsMessage;

  /// No description provided for @privacyAvailableUntil.
  ///
  /// In en, this message translates to:
  /// **'Available until {date}.'**
  String privacyAvailableUntil(String date);

  /// No description provided for @privacyExportExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Export expired. Request a new data export to generate a fresh link.'**
  String get privacyExportExpiredMessage;

  /// No description provided for @privacyExportFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Export failed. Request a new data export to try again.'**
  String get privacyExportFailedMessage;

  /// No description provided for @privacyPreparingExportMessage.
  ///
  /// In en, this message translates to:
  /// **'Preparing export. We will make it available when it is ready.'**
  String get privacyPreparingExportMessage;

  /// No description provided for @privacyPreparingExportRequestedOn.
  ///
  /// In en, this message translates to:
  /// **'Preparing export. Requested on {date}.'**
  String privacyPreparingExportRequestedOn(String date);

  /// No description provided for @privacyDeletionScheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Deletion scheduled for {date}.'**
  String privacyDeletionScheduledFor(String date);

  /// No description provided for @privacyDownloadDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Use this secure link in your browser to download the export archive.'**
  String get privacyDownloadDialogMessage;

  /// No description provided for @privacyDownloadLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Download link copied'**
  String get privacyDownloadLinkCopied;

  /// No description provided for @privacyCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get privacyCopyLink;

  /// No description provided for @privacyYourDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get privacyYourDataTitle;

  /// No description provided for @privacyRequestExport.
  ///
  /// In en, this message translates to:
  /// **'Request data export'**
  String get privacyRequestExport;

  /// No description provided for @privacyRequestDeletion.
  ///
  /// In en, this message translates to:
  /// **'Request account deletion'**
  String get privacyRequestDeletion;

  /// No description provided for @privacyCancelDeletionRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel deletion request'**
  String get privacyCancelDeletionRequest;

  /// No description provided for @mediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Media & Avatars'**
  String get mediaTitle;

  /// No description provided for @mediaReload.
  ///
  /// In en, this message translates to:
  /// **'Reload media'**
  String get mediaReload;

  /// No description provided for @mediaUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Pick, crop and upload image'**
  String get mediaUploadImage;

  /// No description provided for @mediaLastMediaId.
  ///
  /// In en, this message translates to:
  /// **'Last media id: {id}'**
  String mediaLastMediaId(String id);

  /// No description provided for @mediaEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No media objects'**
  String get mediaEmptyTitle;

  /// No description provided for @mediaEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Upload an image to populate media history.'**
  String get mediaEmptyMessage;

  /// No description provided for @mediaItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Media #{id}'**
  String mediaItemTitle(int id);

  /// No description provided for @moneyGoalsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get moneyGoalsSectionTitle;

  /// No description provided for @moneyGoalsSidebarSummary.
  ///
  /// In en, this message translates to:
  /// **'{activeCount} active, {archivedCount} archived'**
  String moneyGoalsSidebarSummary(int activeCount, int archivedCount);

  /// No description provided for @moneyGoalsActiveSection.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get moneyGoalsActiveSection;

  /// No description provided for @moneyGoalsArchivedSection.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get moneyGoalsArchivedSection;

  /// No description provided for @moneyGoalsNoFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a family first'**
  String get moneyGoalsNoFamilyTitle;

  /// No description provided for @moneyGoalsNoFamilyMessage.
  ///
  /// In en, this message translates to:
  /// **'Goals are tied to the selected family. Open family settings to create or join one.'**
  String get moneyGoalsNoFamilyMessage;

  /// No description provided for @moneyGoalsOpenFamilySettings.
  ///
  /// In en, this message translates to:
  /// **'Open family settings'**
  String get moneyGoalsOpenFamilySettings;

  /// No description provided for @moneyGoalsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No goals yet'**
  String get moneyGoalsEmptyTitle;

  /// No description provided for @moneyGoalsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first goal from the detail pane.'**
  String get moneyGoalsEmptyMessage;

  /// No description provided for @moneyGoalsCreateFirstGoal.
  ///
  /// In en, this message translates to:
  /// **'Create first goal'**
  String get moneyGoalsCreateFirstGoal;

  /// No description provided for @moneyGoalsStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get moneyGoalsStatusArchived;

  /// No description provided for @moneyGoalsStatusReached.
  ///
  /// In en, this message translates to:
  /// **'Reached'**
  String get moneyGoalsStatusReached;

  /// No description provided for @moneyGoalsStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get moneyGoalsStatusActive;

  /// No description provided for @moneyGoalsRemainingChip.
  ///
  /// In en, this message translates to:
  /// **'Remaining {amount}'**
  String moneyGoalsRemainingChip(String amount);

  /// No description provided for @moneyGoalsDeadlineChip.
  ///
  /// In en, this message translates to:
  /// **'Deadline {date}'**
  String moneyGoalsDeadlineChip(String date);

  /// No description provided for @moneyGoalsCreateSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new goal'**
  String get moneyGoalsCreateSheetTitle;

  /// No description provided for @moneyGoalsCreateSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a title and the target amount in standard money format.'**
  String get moneyGoalsCreateSheetSubtitle;

  /// No description provided for @moneyGoalsTargetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get moneyGoalsTargetAmountLabel;

  /// No description provided for @moneyGoalsCreateGoalAction.
  ///
  /// In en, this message translates to:
  /// **'Create goal'**
  String get moneyGoalsCreateGoalAction;

  /// No description provided for @moneyGoalsArchivedReadonlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Archived goals stay visible, but their settings can no longer be edited.'**
  String get moneyGoalsArchivedReadonlyMessage;

  /// No description provided for @moneyGoalsAddContributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add contribution'**
  String get moneyGoalsAddContributionTitle;

  /// No description provided for @moneyGoalsAddContributionDescription.
  ///
  /// In en, this message translates to:
  /// **'Top up \"{title}\" with a one-time contribution.'**
  String moneyGoalsAddContributionDescription(String title);

  /// No description provided for @moneyGoalsContributionAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Contribution amount'**
  String get moneyGoalsContributionAmountLabel;

  /// No description provided for @moneyGoalsAddContributionAction.
  ///
  /// In en, this message translates to:
  /// **'Add contribution'**
  String get moneyGoalsAddContributionAction;

  /// No description provided for @moneyGoalsWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw money'**
  String get moneyGoalsWithdrawTitle;

  /// No description provided for @moneyGoalsWithdrawDescription.
  ///
  /// In en, this message translates to:
  /// **'Take money back from \"{title}\".'**
  String moneyGoalsWithdrawDescription(String title);

  /// No description provided for @moneyGoalsWithdrawAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdraw amount'**
  String get moneyGoalsWithdrawAmountLabel;

  /// No description provided for @moneyGoalsWithdrawAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw money'**
  String get moneyGoalsWithdrawAction;

  /// No description provided for @moneyGoalsGoalTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal title'**
  String get moneyGoalsGoalTitleLabel;

  /// No description provided for @moneyGoalsGoalTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Emergency fund'**
  String get moneyGoalsGoalTitleHint;

  /// No description provided for @moneyGoalsDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get moneyGoalsDeadlineLabel;

  /// No description provided for @moneyGoalsDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get moneyGoalsDescriptionLabel;

  /// No description provided for @moneyGoalsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional note for the family'**
  String get moneyGoalsDescriptionHint;

  /// No description provided for @moneyGoalsRemainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get moneyGoalsRemainingLabel;

  /// No description provided for @moneyGoalsCompleteAndArchive.
  ///
  /// In en, this message translates to:
  /// **'Complete and archive'**
  String get moneyGoalsCompleteAndArchive;

  /// No description provided for @moneyGoalsNewGoal.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get moneyGoalsNewGoal;

  /// No description provided for @moneyGoalsProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get moneyGoalsProgressTitle;

  /// No description provided for @moneyGoalsRecentActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get moneyGoalsRecentActivityTitle;

  /// No description provided for @moneyGoalsNoHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No contributions or withdrawals yet.'**
  String get moneyGoalsNoHistoryYet;

  /// No description provided for @moneyGoalsGoalSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal settings'**
  String get moneyGoalsGoalSettingsTitle;

  /// No description provided for @moneyGoalsArchiveGoalAction.
  ///
  /// In en, this message translates to:
  /// **'Archive goal'**
  String get moneyGoalsArchiveGoalAction;

  /// No description provided for @moneyGoalsDeleteGoalAction.
  ///
  /// In en, this message translates to:
  /// **'Delete goal'**
  String get moneyGoalsDeleteGoalAction;

  /// No description provided for @tasksLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading tasks...'**
  String get tasksLoading;

  /// No description provided for @calendarAddEvent.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get calendarAddEvent;

  /// No description provided for @calendarLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading your calendar...'**
  String get calendarLoading;

  /// No description provided for @calendarCreateEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get calendarCreateEventTitle;

  /// No description provided for @calendarSaveEvent.
  ///
  /// In en, this message translates to:
  /// **'Save event'**
  String get calendarSaveEvent;

  /// No description provided for @uiErrorFamilyNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Family is not selected.'**
  String get uiErrorFamilyNotSelected;

  /// No description provided for @uiErrorFamilyTaskNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Family or task is not selected.'**
  String get uiErrorFamilyTaskNotSelected;

  /// No description provided for @uiErrorFamilyGoalNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Family or goal is not selected.'**
  String get uiErrorFamilyGoalNotSelected;

  /// No description provided for @uiErrorArchivedGoalCannotBeEdited.
  ///
  /// In en, this message translates to:
  /// **'Archived goals cannot be edited.'**
  String get uiErrorArchivedGoalCannotBeEdited;

  /// No description provided for @uiErrorFamilyNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Family name cannot be empty.'**
  String get uiErrorFamilyNameEmpty;

  /// No description provided for @uiErrorFamilyRenameQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Family rename queued.'**
  String get uiErrorFamilyRenameQueued;

  /// No description provided for @uiErrorFamilyTransferQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Transfer request queued.'**
  String get uiErrorFamilyTransferQueued;

  /// No description provided for @uiErrorFamilyLeaveQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Leave request queued.'**
  String get uiErrorFamilyLeaveQueued;

  /// No description provided for @uiErrorPrivacyExportQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Export request queued.'**
  String get uiErrorPrivacyExportQueued;

  /// No description provided for @uiErrorPrivacyDeletionQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Deletion request queued.'**
  String get uiErrorPrivacyDeletionQueued;

  /// No description provided for @uiErrorMediaDeleteQueued.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Delete request queued.'**
  String get uiErrorMediaDeleteQueued;

  /// No description provided for @uiErrorExportProcessing.
  ///
  /// In en, this message translates to:
  /// **'Export is still processing. Check back in a moment.'**
  String get uiErrorExportProcessing;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @moneyGoalsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading goals...'**
  String get moneyGoalsLoading;

  /// No description provided for @moneyGoalsEmptyDetailMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first savings goal and start tracking progress.'**
  String get moneyGoalsEmptyDetailMessage;

  /// No description provided for @moneyGoalsPickGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a goal'**
  String get moneyGoalsPickGoalTitle;

  /// No description provided for @moneyGoalsPickGoalMessage.
  ///
  /// In en, this message translates to:
  /// **'Select a goal from the active list or archive to inspect progress and actions.'**
  String get moneyGoalsPickGoalMessage;

  /// No description provided for @moneyGoalsCreateAnotherGoal.
  ///
  /// In en, this message translates to:
  /// **'Create another goal'**
  String get moneyGoalsCreateAnotherGoal;

  /// No description provided for @moneyGoalsNoDeadlineSet.
  ///
  /// In en, this message translates to:
  /// **'No deadline set'**
  String get moneyGoalsNoDeadlineSet;

  /// No description provided for @moneyGoalsPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get moneyGoalsPickDate;

  /// No description provided for @moneyGoalsGoalTitleValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a goal title'**
  String get moneyGoalsGoalTitleValidation;

  /// No description provided for @moneyGoalsAmountValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get moneyGoalsAmountValidation;

  /// No description provided for @taskEditorAssigneeLabel.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get taskEditorAssigneeLabel;

  /// No description provided for @tasksSummaryOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get tasksSummaryOpen;

  /// No description provided for @tasksSummaryDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get tasksSummaryDueToday;

  /// No description provided for @tasksSummaryOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get tasksSummaryOverdue;

  /// No description provided for @tasksSummaryArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get tasksSummaryArchive;

  /// No description provided for @tasksEmptyArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive is empty'**
  String get tasksEmptyArchiveTitle;

  /// No description provided for @tasksEmptyArchiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks will appear here once something is checked off.'**
  String get tasksEmptyArchiveMessage;

  /// No description provided for @tasksEmptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks match this view'**
  String get tasksEmptyFilteredTitle;

  /// No description provided for @tasksEmptyFilteredMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another filter or create a new task to get things moving.'**
  String get tasksEmptyFilteredMessage;

  /// No description provided for @tasksTaskCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} task} other{{count} tasks}}'**
  String tasksTaskCount(int count);

  /// No description provided for @tasksPickTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a task'**
  String get tasksPickTaskTitle;

  /// No description provided for @tasksPickTaskMessage.
  ///
  /// In en, this message translates to:
  /// **'Select any task from the workspace to inspect details, reminders, and history.'**
  String get tasksPickTaskMessage;

  /// No description provided for @tasksDetailCompletedItem.
  ///
  /// In en, this message translates to:
  /// **'Completed item'**
  String get tasksDetailCompletedItem;

  /// No description provided for @tasksDetailOpenFamilyTask.
  ///
  /// In en, this message translates to:
  /// **'Open family task'**
  String get tasksDetailOpenFamilyTask;

  /// No description provided for @tasksMetaPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get tasksMetaPersonal;

  /// No description provided for @tasksMetaShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get tasksMetaShared;

  /// No description provided for @tasksActionComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get tasksActionComplete;

  /// No description provided for @tasksActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get tasksActionEdit;

  /// No description provided for @tasksActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tasksActionDelete;

  /// No description provided for @tasksHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tasksHistoryTitle;

  /// No description provided for @tasksNoHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get tasksNoHistoryTitle;

  /// No description provided for @tasksNoHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Changes and completion activity will appear here.'**
  String get tasksNoHistoryMessage;

  /// No description provided for @tasksStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tasksStatusCompleted;

  /// No description provided for @tasksStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get tasksStatusOpen;

  /// No description provided for @tasksNoFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a family first'**
  String get tasksNoFamilyTitle;

  /// No description provided for @tasksNoFamilyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tasks are tied to the selected family. Open family settings to create or join one.'**
  String get tasksNoFamilyMessage;

  /// No description provided for @tasksOpenFamilySettings.
  ///
  /// In en, this message translates to:
  /// **'Open family settings'**
  String get tasksOpenFamilySettings;

  /// No description provided for @tasksSectionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get tasksSectionOverdue;

  /// No description provided for @tasksSectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasksSectionToday;

  /// No description provided for @tasksSectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tasksSectionUpcoming;

  /// No description provided for @tasksSectionNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get tasksSectionNoDueDate;

  /// No description provided for @tasksFilterAllOpen.
  ///
  /// In en, this message translates to:
  /// **'All open'**
  String get tasksFilterAllOpen;

  /// No description provided for @tasksFilterMine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get tasksFilterMine;

  /// No description provided for @tasksFilterUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get tasksFilterUnassigned;

  /// No description provided for @tasksFilterDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get tasksFilterDueSoon;

  /// No description provided for @tasksFilterCompletedArchive.
  ///
  /// In en, this message translates to:
  /// **'Completed archive'**
  String get tasksFilterCompletedArchive;

  /// No description provided for @tasksHistoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get tasksHistoryCreated;

  /// No description provided for @tasksHistoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get tasksHistoryUpdated;

  /// No description provided for @tasksHistoryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tasksHistoryCompleted;

  /// No description provided for @tasksAssigneeMemberYou.
  ///
  /// In en, this message translates to:
  /// **'{name} (you)'**
  String tasksAssigneeMemberYou(String name);

  /// No description provided for @tasksAssigneeYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get tasksAssigneeYou;

  /// No description provided for @tasksAssigneeUser.
  ///
  /// In en, this message translates to:
  /// **'User {profileId}'**
  String tasksAssigneeUser(int profileId);

  /// No description provided for @tasksNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get tasksNoDueDate;

  /// No description provided for @tasksDueChip.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String tasksDueChip(String date);

  /// No description provided for @tasksOfflineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Tasks are unavailable while offline.'**
  String get tasksOfflineUnavailable;

  /// No description provided for @tasksDeleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get tasksDeleteTaskTitle;

  /// No description provided for @tasksDeleteTaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\" permanently from active tasks and archive.'**
  String tasksDeleteTaskDescription(String title);

  /// No description provided for @tasksDeleteTaskConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get tasksDeleteTaskConfirm;

  /// No description provided for @moneyGoalsSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Goals snapshot'**
  String get moneyGoalsSummaryTitle;

  /// No description provided for @moneyGoalsSummaryActiveGoals.
  ///
  /// In en, this message translates to:
  /// **'Active goals'**
  String get moneyGoalsSummaryActiveGoals;

  /// No description provided for @moneyGoalsSummaryArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get moneyGoalsSummaryArchived;

  /// No description provided for @moneyGoalsSummaryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get moneyGoalsSummaryCompleted;

  /// No description provided for @moneyGoalsSummarySavedTotal.
  ///
  /// In en, this message translates to:
  /// **'Saved total'**
  String get moneyGoalsSummarySavedTotal;

  /// No description provided for @moneyGoalsGoalCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} goal} other{{count} goals}}'**
  String moneyGoalsGoalCount(int count);

  /// No description provided for @moneyGoalsNoActiveGoalsMessage.
  ///
  /// In en, this message translates to:
  /// **'No active goals right now. Archived goals stay below for reference.'**
  String get moneyGoalsNoActiveGoalsMessage;

  /// No description provided for @moneyGoalsArchiveGoalConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive goal'**
  String get moneyGoalsArchiveGoalConfirmTitle;

  /// No description provided for @moneyGoalsArchiveGoalConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'Archive \"{title}\"? It will stay visible, but editing will be locked.'**
  String moneyGoalsArchiveGoalConfirmDescription(String title);

  /// No description provided for @moneyGoalsDeleteGoalConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete goal'**
  String get moneyGoalsDeleteGoalConfirmTitle;

  /// No description provided for @moneyGoalsDeleteGoalConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\" permanently from active and archived goals.'**
  String moneyGoalsDeleteGoalConfirmDescription(String title);

  /// No description provided for @moneyGoalsProgressOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target}'**
  String moneyGoalsProgressOf(String current, String target);

  /// No description provided for @moneyGoalsStatusArchivedOn.
  ///
  /// In en, this message translates to:
  /// **'Archived on {date}'**
  String moneyGoalsStatusArchivedOn(String date);

  /// No description provided for @moneyGoalsStatusReachedOn.
  ///
  /// In en, this message translates to:
  /// **'Reached on {date}'**
  String moneyGoalsStatusReachedOn(String date);

  /// No description provided for @moneyGoalsStatusUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String moneyGoalsStatusUpdatedAt(String date);

  /// No description provided for @moneyGoalsHistoryWithdrew.
  ///
  /// In en, this message translates to:
  /// **'{name} withdrew {amount}'**
  String moneyGoalsHistoryWithdrew(String name, String amount);

  /// No description provided for @moneyGoalsHistoryAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added {amount}'**
  String moneyGoalsHistoryAdded(String name, String amount);

  /// No description provided for @calendarEditOccurrenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit occurrence'**
  String get calendarEditOccurrenceTitle;

  /// No description provided for @calendarEditFollowingTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit this and following'**
  String get calendarEditFollowingTitle;

  /// No description provided for @calendarEditWholeSeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit whole series'**
  String get calendarEditWholeSeriesTitle;

  /// No description provided for @calendarDeleteOccurrenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete occurrence'**
  String get calendarDeleteOccurrenceTitle;

  /// No description provided for @calendarDeleteOccurrenceMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove only this occurrence from the series?'**
  String get calendarDeleteOccurrenceMessage;

  /// No description provided for @calendarDeleteSeriesFutureMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this and all following occurrences?'**
  String get calendarDeleteSeriesFutureMessage;

  /// No description provided for @calendarDeleteSeriesAllMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete the entire recurring series?'**
  String get calendarDeleteSeriesAllMessage;

  /// No description provided for @calendarDeleteEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete event'**
  String get calendarDeleteEventTitle;

  /// No description provided for @calendarOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'This action will sync when your connection returns.'**
  String get calendarOfflineMessage;

  /// No description provided for @calendarYourScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Your schedule'**
  String get calendarYourScheduleTitle;

  /// No description provided for @calendarUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get calendarUpdatingStatus;

  /// No description provided for @calendarRefreshingStatus.
  ///
  /// In en, this message translates to:
  /// **'Refreshing'**
  String get calendarRefreshingStatus;

  /// No description provided for @calendarSavingStatus.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get calendarSavingStatus;

  /// No description provided for @calendarFormatMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarFormatMonth;

  /// No description provided for @calendarPlansForDay.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} plan for this day} other{{count} plans for this day}}'**
  String calendarPlansForDay(int count);

  /// No description provided for @calendarOpenDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Open day'**
  String get calendarOpenDayTitle;

  /// No description provided for @calendarNextEventSummary.
  ///
  /// In en, this message translates to:
  /// **'Next: {timeRange} • {title}'**
  String calendarNextEventSummary(String timeRange, String title);

  /// No description provided for @calendarOpenDayEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Nothing is scheduled yet. Add an event to keep the day organized.'**
  String get calendarOpenDayEmptyMessage;

  /// No description provided for @calendarAgendaTitle.
  ///
  /// In en, this message translates to:
  /// **'Day agenda'**
  String get calendarAgendaTitle;

  /// No description provided for @calendarEventsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} event} other{{count} events}}'**
  String calendarEventsCount(int count);

  /// No description provided for @calendarEmptyDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned yet'**
  String get calendarEmptyDayTitle;

  /// No description provided for @calendarEmptyDayMessage.
  ///
  /// In en, this message translates to:
  /// **'Create an event for this day and it will appear here with the right repeat and reminder settings.'**
  String get calendarEmptyDayMessage;

  /// No description provided for @calendarRepeatsChip.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get calendarRepeatsChip;

  /// No description provided for @calendarEditedChip.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get calendarEditedChip;

  /// No description provided for @calendarReminderAtTime.
  ///
  /// In en, this message translates to:
  /// **'At time'**
  String get calendarReminderAtTime;

  /// No description provided for @calendarReminderTenMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'10m before'**
  String get calendarReminderTenMinutesBefore;

  /// No description provided for @calendarReminderOneHourBefore.
  ///
  /// In en, this message translates to:
  /// **'1h before'**
  String get calendarReminderOneHourBefore;

  /// No description provided for @calendarReminderOneDayBefore.
  ///
  /// In en, this message translates to:
  /// **'1d before'**
  String get calendarReminderOneDayBefore;

  /// No description provided for @calendarReminderGeneric.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get calendarReminderGeneric;

  /// No description provided for @calendarActionEditSection.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get calendarActionEditSection;

  /// No description provided for @calendarActionDeleteSection.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get calendarActionDeleteSection;

  /// No description provided for @calendarActionEditOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Edit this occurrence'**
  String get calendarActionEditOccurrence;

  /// No description provided for @calendarActionEditFollowing.
  ///
  /// In en, this message translates to:
  /// **'Edit this and following'**
  String get calendarActionEditFollowing;

  /// No description provided for @calendarActionEditWholeSeries.
  ///
  /// In en, this message translates to:
  /// **'Edit whole series'**
  String get calendarActionEditWholeSeries;

  /// No description provided for @calendarActionEditEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get calendarActionEditEvent;

  /// No description provided for @calendarActionDeleteOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Delete this occurrence'**
  String get calendarActionDeleteOccurrence;

  /// No description provided for @calendarActionDeleteFollowing.
  ///
  /// In en, this message translates to:
  /// **'Delete this and following'**
  String get calendarActionDeleteFollowing;

  /// No description provided for @calendarActionDeleteWholeSeries.
  ///
  /// In en, this message translates to:
  /// **'Delete whole series'**
  String get calendarActionDeleteWholeSeries;

  /// No description provided for @calendarActionDeleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete event'**
  String get calendarActionDeleteEvent;

  /// No description provided for @calendarEditorRecurringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set time, reminders, and repeat rules in one place.'**
  String get calendarEditorRecurringSubtitle;

  /// No description provided for @calendarEditorSingleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update this single occurrence without changing the full series.'**
  String get calendarEditorSingleSubtitle;

  /// No description provided for @calendarEditorBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get calendarEditorBasicsTitle;

  /// No description provided for @calendarEditorBasicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A clear title helps the whole family scan the day faster.'**
  String get calendarEditorBasicsSubtitle;

  /// No description provided for @calendarEditorTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Event title'**
  String get calendarEditorTitleLabel;

  /// No description provided for @calendarEditorNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get calendarEditorNotesLabel;

  /// No description provided for @calendarEditorOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get calendarEditorOptionalHint;

  /// No description provided for @calendarEditorScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get calendarEditorScheduleTitle;

  /// No description provided for @calendarEditorScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a polished start and end time for the event.'**
  String get calendarEditorScheduleSubtitle;

  /// No description provided for @calendarEditorStartsLabel.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get calendarEditorStartsLabel;

  /// No description provided for @calendarEditorEndsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get calendarEditorEndsLabel;

  /// No description provided for @calendarEditorReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get calendarEditorReminderTitle;

  /// No description provided for @calendarEditorReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications should appear only when they are helpful.'**
  String get calendarEditorReminderSubtitle;

  /// No description provided for @calendarEditorRepeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get calendarEditorRepeatTitle;

  /// No description provided for @calendarEditorRepeatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep repeat rules visible and only reveal the controls that matter.'**
  String get calendarEditorRepeatSubtitle;

  /// No description provided for @calendarEditorDaysOfWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Days of week'**
  String get calendarEditorDaysOfWeekLabel;

  /// No description provided for @calendarEditorRepeatEveryDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat every N days'**
  String get calendarEditorRepeatEveryDaysLabel;

  /// No description provided for @calendarEditorTitleValidation.
  ///
  /// In en, this message translates to:
  /// **'Please add an event title.'**
  String get calendarEditorTitleValidation;

  /// No description provided for @calendarEditorEndAfterStartValidation.
  ///
  /// In en, this message translates to:
  /// **'End time must be after the start time.'**
  String get calendarEditorEndAfterStartValidation;

  /// No description provided for @calendarEditorIntervalValidation.
  ///
  /// In en, this message translates to:
  /// **'Repeat interval should be at least 1 day.'**
  String get calendarEditorIntervalValidation;

  /// No description provided for @calendarRecurrenceNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get calendarRecurrenceNoneTitle;

  /// No description provided for @calendarRecurrenceYearlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Every year on this day'**
  String get calendarRecurrenceYearlyTitle;

  /// No description provided for @calendarRecurrenceMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Every month on this day'**
  String get calendarRecurrenceMonthlyTitle;

  /// No description provided for @calendarRecurrenceWeeklyTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected weekdays'**
  String get calendarRecurrenceWeeklyTitle;

  /// No description provided for @calendarRecurrenceEveryNDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Every N days'**
  String get calendarRecurrenceEveryNDaysTitle;

  /// No description provided for @calendarRecurrenceNoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time event.'**
  String get calendarRecurrenceNoneSubtitle;

  /// No description provided for @calendarRecurrenceYearlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Useful for birthdays and anniversaries.'**
  String get calendarRecurrenceYearlySubtitle;

  /// No description provided for @calendarRecurrenceMonthlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Runs on the same day number every month.'**
  String get calendarRecurrenceMonthlySubtitle;

  /// No description provided for @calendarRecurrenceWeeklySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose one or several weekdays.'**
  String get calendarRecurrenceWeeklySubtitle;

  /// No description provided for @calendarRecurrenceEveryNDaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Great for routines with a fixed interval.'**
  String get calendarRecurrenceEveryNDaysSubtitle;

  /// No description provided for @calendarDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String calendarDurationHours(int hours);

  /// No description provided for @calendarDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String calendarDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @calendarDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String calendarDurationMinutes(int minutes);

  /// No description provided for @calendarMutationScopeOne.
  ///
  /// In en, this message translates to:
  /// **'This occurrence'**
  String get calendarMutationScopeOne;

  /// No description provided for @calendarMutationScopeFuture.
  ///
  /// In en, this message translates to:
  /// **'This and following'**
  String get calendarMutationScopeFuture;

  /// No description provided for @calendarMutationScopeAll.
  ///
  /// In en, this message translates to:
  /// **'Whole series'**
  String get calendarMutationScopeAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
