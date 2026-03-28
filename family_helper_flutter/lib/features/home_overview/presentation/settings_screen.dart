import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_defaults.dart';
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

    return Scaffold(
      appBar: serverStatusAppBar(context, title: const Text('Settings')),
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
                  )
                : _buildNarrowContent(
                    profileState: profileState,
                    familyState: familyState,
                    notificationsState: notificationsState,
                    privacyState: privacyState,
                    themeMode: themeMode,
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
    final profile = state.profile;
    if (state.isLoading && profile == null) {
      return 'Loading profile…';
    }
    if (profile == null) {
      return 'Update your name, timezone, and photo';
    }
    final photoStatus = profile.avatarMediaId == null
        ? 'No photo'
        : 'Photo added';
    return '${profile.displayName} • ${profile.timezone} • $photoStatus';
  }

  String _familySummary(FamilyMembersState state) {
    if (state.familyId == null) {
      return 'Not connected';
    }
    if (state.isLoading && state.family == null) {
      return 'Loading family…';
    }
    final family = state.family;
    if (family == null) {
      return 'Family connected';
    }
    final count = state.members.length;
    final memberLabel = count == 1 ? 'member' : 'members';
    return '${family.title} • $count $memberLabel';
  }

  String _notificationsSummary(NotificationsState state) {
    final taskReminders =
        state.preferences.any(
          (preference) =>
              preference.notificationType == AppDefaults.taskNotificationType &&
              preference.enabled,
        )
        ? 'On'
        : 'Off';
    final calendarReminders =
        state.preferences.any(
          (preference) =>
              preference.notificationType ==
                  AppDefaults.calendarNotificationType &&
              preference.enabled,
        )
        ? 'On'
        : 'Off';
    return '${state.permissionStatus.summaryLabel} • Task $taskReminders • Calendar $calendarReminders';
  }

  String _privacySummary({
    required PrivacyState privacyState,
    required ProfileState profileState,
  }) {
    final analytics = profileState.profile?.analyticsOptIn == true
        ? 'Analytics on'
        : 'Analytics off';
    if (privacyState.hasActiveDeletionRequest) {
      return '$analytics • Deletion scheduled';
    }
    if (privacyState.canDownloadExport) {
      return '$analytics • Export ready';
    }
    if (privacyState.isExportExpired) {
      return '$analytics • Export expired';
    }
    if (privacyState.lastExportJob?.status == 'failed') {
      return '$analytics • Export failed';
    }
    if (privacyState.lastExportJob != null) {
      return '$analytics • Preparing export';
    }
    return '$analytics • No active requests';
  }

  static String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
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
        const _SectionTitle('Account'),
        AppTile(
          title: 'Profile',
          subtitle: profileSummary,
          onTap: () => context.go(AppRoutes.profile),
        ),
        AppTile(
          title: 'Family',
          subtitle: familySummary,
          onTap: () => context.go(AppRoutes.family),
        ),
        AppTile(
          title: 'Notifications',
          subtitle: notificationsSummary,
          onTap: () => context.push(AppRoutes.notificationSettings),
        ),
        AppTile(
          title: 'Privacy',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('Appearance'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Current mode: ${_SettingsScreenState._themeModeLabel(themeMode)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('System'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
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
      label: 'Sign out',
      variant: AppButtonVariant.danger,
      onPressed: onPressed == null
          ? null
          : () async {
              await onPressed!();
            },
    );
  }
}
