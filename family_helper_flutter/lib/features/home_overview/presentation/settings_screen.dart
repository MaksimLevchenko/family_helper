import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_session.dart';
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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTile(
            title: 'Profile',
            onTap: () => context.go(AppRoutes.profile),
          ),
          AppTile(
            title: 'Family & Invites',
            onTap: () => context.go(AppRoutes.family),
          ),
          AppTile(
            title: 'Local reminders',
            subtitle: 'Session-only debug panel until push flow is wired',
            onTap: () => context.go(AppRoutes.localReminders),
          ),
          AppTile(
            title: 'Media & Avatars',
            onTap: () => context.go(AppRoutes.media),
          ),
          AppTile(
            title: 'Privacy & Security',
            subtitle: 'Session-only status until read API is added',
            onTap: () => context.go(AppRoutes.privacy),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeCubit>().setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
            title: const Text('Dark theme'),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Sign out',
            variant: AppButtonVariant.danger,
            onPressed: () async {
              final familySelectionCubit = context.read<FamilySelectionCubit>();
              context.read<NotificationsCubit>().reset();
              context.read<MediaCubit>().reset();
              context.read<PrivacyCubit>().reset();
              context.read<ListsCubit>().reset();
              context.read<MoneyGoalsCubit>().reset();
              context.read<TasksCubit>().reset();
              context.read<CalendarCubit>().reset();
              context.read<FamilyMembersCubit>().reset();
              context.read<ProfileBloc>().add(const ProfileResetRequested());
              final authCubit = context.read<AuthCubit>();
              await familySelectionCubit.clear();
              await authCubit.signOut();
            },
          ),
        ],
      ),
    );
  }
}
