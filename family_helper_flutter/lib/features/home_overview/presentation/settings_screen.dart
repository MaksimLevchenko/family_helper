import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:family_helper_client/family_helper_client.dart';

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
import '../../notifications/providers/notifications_provider.dart';
import '../../privacy_security/providers/privacy_provider.dart';
import '../../tasks/providers/tasks_provider.dart';

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
      if (notificationsCubit != null &&
          notificationsCubit.state.preferences.isEmpty) {
        notificationsCubit.loadPreferences();
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
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Account'),
          AppTile(
            title: 'Profile',
            subtitle: _profileSummary(profileState),
            onTap: () => context.go(AppRoutes.profile),
          ),
          AppTile(
            title: 'Family',
            subtitle: _familySummary(familyState),
            onTap: () => context.go(AppRoutes.family),
          ),
          AppTile(
            title: 'Notifications',
            subtitle: _notificationsSummary(notificationsState),
            onTap: () => context.go(AppRoutes.localReminders),
          ),
          AppTile(
            title: 'Privacy',
            subtitle: _privacySummary(
              privacyState: privacyState,
              profileState: profileState,
            ),
            onTap: () => context.go(AppRoutes.privacy),
          ),
          const SizedBox(height: 16),
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
                    'Current mode: ${_themeModeLabel(themeMode)}',
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
          const SizedBox(height: 24),
          AppButton(
            label: 'Sign out',
            variant: AppButtonVariant.danger,
            onPressed: () async {
              final familySelectionCubit = context
                  .read<FamilySelectionCubit?>();
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
            },
          ),
        ],
      ),
    );
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
    NotificationPreferenceDto? taskPreference;
    for (final preference in state.preferences) {
      if (preference.notificationType == AppDefaults.defaultNotificationType) {
        taskPreference = preference;
        break;
      }
    }
    final permission = state.localNotificationsEnabled
        ? 'Allowed'
        : 'Not enabled';
    final taskReminders = taskPreference?.enabled == true ? 'On' : 'Off';
    return '$permission • Task reminders $taskReminders';
  }

  String _privacySummary({
    required PrivacyState privacyState,
    required ProfileState profileState,
  }) {
    final analytics = profileState.profile?.analyticsOptIn == true
        ? 'Analytics on'
        : 'Analytics off';
    final exportJob = privacyState.lastExportJob;
    final deletion = privacyState.accountDeletion;
    if (deletion != null && deletion.status != 'cancelled') {
      return '$analytics • Deletion ${_statusLabel(deletion.status)}';
    }
    if (exportJob != null) {
      final exportLabel = exportJob.signedUrl == null
          ? 'Export ${_statusLabel(exportJob.status)}'
          : 'Export ready';
      return '$analytics • $exportLabel';
    }
    return '$analytics • No active requests';
  }

  String _statusLabel(String status) {
    return switch (status) {
      'requested' => 'requested',
      'pending' => 'pending',
      'processing' => 'processing',
      'scheduled' => 'scheduled',
      'completed' => 'completed',
      'cancelled' => 'cancelled',
      _ => status,
    };
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
