import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_defaults.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../auth_profile/providers/profile_provider.dart';
import '../../calendar/providers/calendar_provider.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../lists/providers/lists_provider.dart';
import '../../media/providers/media_provider.dart';
import '../../money_goals/providers/money_goals_provider.dart';
import '../../notifications/domain/notification_models.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../privacy_security/providers/privacy_provider.dart';
import '../../tasks/providers/tasks_provider.dart';

const _wideLayoutBreakpoint = 920.0;
const _maxContentWidth = 1120.0;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileBloc = context.read<ProfileBloc?>();
      if (profileBloc != null && profileBloc.state.profile == null) {
        profileBloc.add(const ProfileLoadRequested());
      }

      final notificationsCubit = context.read<NotificationsCubit?>();
      if (notificationsCubit != null) {
        if (notificationsCubit.state.preferences.isEmpty) {
          notificationsCubit.loadPreferences();
        }
        notificationsCubit.refreshPermissionStatus();
      }

      final privacyCubit = context.read<PrivacyCubit?>();
      if (privacyCubit != null &&
          privacyCubit.state.lastExportJob == null &&
          privacyCubit.state.accountDeletion == null) {
        privacyCubit.reloadStatus();
      }

      final familySelectionCubit = context.read<FamilySelectionCubit?>();
      final familyMembersCubit = context.read<FamilyMembersCubit?>();
      if (familySelectionCubit != null &&
          familyMembersCubit != null &&
          familySelectionCubit.state != null &&
          familyMembersCubit.state.family == null &&
          !familyMembersCubit.state.isLoading) {
        familyMembersCubit.loadMembers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState =
        context.watch<ProfileBloc?>()?.state ?? ProfileState.initial();
    final familyState =
        context.watch<FamilyMembersCubit?>()?.state ??
        FamilyMembersState.initial();
    final notificationsState =
        context.watch<NotificationsCubit?>()?.state ??
        NotificationsState.initial();
    final privacyState =
        context.watch<PrivacyCubit?>()?.state ?? const PrivacyState();
    final themeMode = context.watch<ThemeCubit>().state;
    final localeState = context.watch<LocaleCubit>().state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: serverStatusAppBar(context, title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
            final content = isWide
                ? _buildWideContent(
                    profileState: profileState,
                    familyState: familyState,
                    notificationsState: notificationsState,
                    privacyState: privacyState,
                    themeMode: themeMode,
                    localeState: localeState,
                  )
                : _buildNarrowContent(
                    profileState: profileState,
                    familyState: familyState,
                    notificationsState: notificationsState,
                    privacyState: privacyState,
                    themeMode: themeMode,
                    localeState: localeState,
                  );

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? _maxContentWidth : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isWide ? 24 : 16),
                  child: content,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNarrowContent({
    required ProfileState profileState,
    required FamilyMembersState familyState,
    required NotificationsState notificationsState,
    required PrivacyState privacyState,
    required ThemeMode themeMode,
    required AppLocaleState localeState,
  }) {
    return Column(
      key: const ValueKey('settings-layout-narrow'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AccountSection(
          profileSummary: _profileSummary(profileState),
          familySummary: _familySummary(familyState),
          notificationsSummary: _notificationsSummary(notificationsState),
          privacySummary: _privacySummary(
            privacyState: privacyState,
            profileState: profileState,
          ),
        ),
        const SizedBox(height: 16),
        _AppearanceCard(themeMode: themeMode),
        const SizedBox(height: 16),
        _LanguageCard(localeState: localeState),
        const SizedBox(height: 24),
        _SignOutButton(onPressed: _handleSignOut),
      ],
    );
  }

  Widget _buildWideContent({
    required ProfileState profileState,
    required FamilyMembersState familyState,
    required NotificationsState notificationsState,
    required PrivacyState privacyState,
    required ThemeMode themeMode,
    required AppLocaleState localeState,
  }) {
    return Row(
      key: const ValueKey('settings-layout-wide'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: _AccountSection(
            key: const ValueKey('settings-account-column'),
            profileSummary: _profileSummary(profileState),
            familySummary: _familySummary(familyState),
            notificationsSummary: _notificationsSummary(notificationsState),
            privacySummary: _privacySummary(
              privacyState: privacyState,
              profileState: profileState,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 5,
          child: Column(
            key: const ValueKey('settings-secondary-column'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AppearanceCard(themeMode: themeMode),
              const SizedBox(height: 24),
              _LanguageCard(localeState: localeState),
              const SizedBox(height: 24),
              _SignOutCard(onPressed: _handleSignOut),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignOut() async {
    final familySelectionCubit = context.read<FamilySelectionCubit?>();
    context.read<NotificationsCubit?>()?.reset();
    context.read<MediaCubit?>()?.reset();
    context.read<PrivacyCubit?>()?.reset();
    context.read<ListsCubit?>()?.reset();
    context.read<MoneyGoalsCubit?>()?.reset();
    context.read<TasksCubit?>()?.reset();
    context.read<CalendarCubit?>()?.reset();
    context.read<FamilyMembersCubit?>()?.reset();
    context.read<ProfileBloc?>()?.add(const ProfileResetRequested());
    final authCubit = context.read<AuthCubit?>();
    if (familySelectionCubit == null || authCubit == null) {
      return;
    }
    await familySelectionCubit.clear();
    await authCubit.signOut();
  }

  String _profileSummary(ProfileState state) {
    final l10n = context.l10n;
    final profile = state.profile;
    if (state.isLoading && profile == null) {
      return l10n.settingsProfileSummaryLoading;
    }
    if (profile == null) {
      return l10n.settingsProfileSummaryEmpty;
    }
    final photoStatus = profile.avatarMediaId == null
        ? l10n.settingsPhotoMissing
        : l10n.settingsPhotoAdded;
    return '${profile.displayName} • ${profile.timezone} • $photoStatus';
  }

  String _familySummary(FamilyMembersState state) {
    final l10n = context.l10n;
    if (state.familyId == null) {
      return l10n.settingsFamilySummaryNotConnected;
    }
    if (state.isLoading && state.family == null) {
      return l10n.settingsFamilySummaryLoading;
    }
    final family = state.family;
    if (family == null) {
      return l10n.settingsFamilySummaryConnected;
    }
    final count = state.members.length;
    return '${family.title} • ${l10n.settingsMemberCount(count)}';
  }

  String _notificationsSummary(NotificationsState state) {
    final l10n = context.l10n;
    final taskReminders =
        state.preferences.any(
          (preference) =>
              preference.notificationType == AppDefaults.taskNotificationType &&
              preference.enabled,
        )
        ? l10n.settingsSwitchOn
        : l10n.settingsSwitchOff;
    final calendarReminders =
        state.preferences.any(
          (preference) =>
              preference.notificationType ==
                  AppDefaults.calendarNotificationType &&
              preference.enabled,
        )
        ? l10n.settingsSwitchOn
        : l10n.settingsSwitchOff;
    return l10n.settingsNotificationsSummary(
      state.permissionStatus.summaryLabel(l10n),
      taskReminders,
      calendarReminders,
    );
  }

  String _privacySummary({
    required PrivacyState privacyState,
    required ProfileState profileState,
  }) {
    final l10n = context.l10n;
    final analytics = profileState.profile?.analyticsOptIn == true
        ? l10n.settingsAnalyticsOn
        : l10n.settingsAnalyticsOff;
    if (privacyState.hasActiveDeletionRequest) {
      return '$analytics • ${l10n.settingsDeletionScheduled}';
    }
    if (privacyState.canDownloadExport) {
      return '$analytics • ${l10n.settingsExportReady}';
    }
    if (privacyState.isExportExpired) {
      return '$analytics • ${l10n.settingsExportExpired}';
    }
    if (privacyState.lastExportJob?.status == 'failed') {
      return '$analytics • ${l10n.settingsExportFailed}';
    }
    if (privacyState.lastExportJob != null) {
      return '$analytics • ${l10n.settingsPreparingExport}';
    }
    return '$analytics • ${l10n.settingsNoActiveRequests}';
  }

  static String _themeModeLabel(BuildContext context, ThemeMode mode) {
    final l10n = context.l10n;
    return switch (mode) {
      ThemeMode.system => l10n.themeModeSystem,
      ThemeMode.light => l10n.themeModeLight,
      ThemeMode.dark => l10n.themeModeDark,
    };
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({
    required this.profileSummary,
    required this.familySummary,
    required this.notificationsSummary,
    required this.privacySummary,
    super.key,
  });

  final String profileSummary;
  final String familySummary;
  final String notificationsSummary;
  final String privacySummary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(context.l10n.settingsAccountSection),
        AppTile(
          title: context.l10n.settingsProfileTitle,
          subtitle: profileSummary,
          onTap: () => context.go(AppRoutes.profile),
        ),
        AppTile(
          title: context.l10n.settingsFamilyTitle,
          subtitle: familySummary,
          onTap: () => context.go(AppRoutes.family),
        ),
        AppTile(
          title: context.l10n.settingsNotificationsTitle,
          subtitle: notificationsSummary,
          onTap: () => context.push(AppRoutes.notificationSettings),
        ),
        AppTile(
          title: context.l10n.settingsPrivacyTitle,
          subtitle: privacySummary,
          onTap: () => context.go(AppRoutes.privacy),
        ),
      ],
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard({required this.themeMode});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(l10n.settingsAppearanceSection),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsThemeTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsCurrentMode(
                    _SettingsScreenState._themeModeLabel(context, themeMode),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text(l10n.themeModeSystem),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text(l10n.themeModeLight),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text(l10n.themeModeDark),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) async {
                    await context.read<ThemeCubit>().setThemeMode(
                      selection.first,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.localeState});

  final AppLocaleState localeState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeCubit = context.read<LocaleCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(l10n.settingsLanguageSection),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsLanguageTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsLanguageSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment<String>(
                      value: 'system',
                      label: Text(l10n.settingsLanguageSystem),
                    ),
                    ButtonSegment<String>(
                      value: 'en',
                      label: Text(l10n.settingsLanguageEnglish),
                    ),
                    ButtonSegment<String>(
                      value: 'ru',
                      label: Text(l10n.settingsLanguageRussian),
                    ),
                  ],
                  selected: {
                    localeState.mode == AppLocaleMode.system
                        ? 'system'
                        : localeState.manualLocale.languageCode,
                  },
                  onSelectionChanged: (selection) async {
                    final value = selection.first;
                    if (value == 'system') {
                      await localeCubit.setSystemMode();
                      return;
                    }
                    await localeCubit.setManualLocale(Locale(value));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SignOutCard extends StatelessWidget {
  const _SignOutCard({required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _SignOutButton(onPressed: onPressed),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({this.onPressed});

  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: context.l10n.settingsSignOut,
      variant: AppButtonVariant.danger,
      onPressed: onPressed == null
          ? null
          : () async {
              await onPressed!();
            },
    );
  }
}
