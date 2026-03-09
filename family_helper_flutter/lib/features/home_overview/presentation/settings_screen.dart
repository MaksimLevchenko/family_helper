import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../auth_profile/presentation/profile_screen.dart';
import '../../auth_profile/providers/profile_provider.dart';
import '../../family_invites/presentation/family_screen.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../media/presentation/media_screen.dart';
import '../../media/providers/media_provider.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../privacy_security/presentation/privacy_security_screen.dart';
import '../../privacy_security/providers/privacy_provider.dart';

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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<ProfileBloc>.value(
                  value: context.read<ProfileBloc>(),
                  child: const ProfileScreen(),
                ),
              ),
            ),
          ),
          AppTile(
            title: 'Family & Invites',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<FamilySelectionCubit>.value(
                      value: context.read<FamilySelectionCubit>(),
                    ),
                    BlocProvider<FamilyMembersCubit>.value(
                      value: context.read<FamilyMembersCubit>(),
                    ),
                  ],
                  child: const FamilyScreen(),
                ),
              ),
            ),
          ),
          AppTile(
            title: 'Notifications',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<NotificationsCubit>.value(
                  value: context.read<NotificationsCubit>(),
                  child: const NotificationsScreen(),
                ),
              ),
            ),
          ),
          AppTile(
            title: 'Media & Avatars',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<MediaCubit>.value(
                  value: context.read<MediaCubit>(),
                  child: const MediaScreen(),
                ),
              ),
            ),
          ),
          AppTile(
            title: 'Privacy & Security',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<PrivacyCubit>.value(
                  value: context.read<PrivacyCubit>(),
                  child: const PrivacySecurityScreen(),
                ),
              ),
            ),
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
