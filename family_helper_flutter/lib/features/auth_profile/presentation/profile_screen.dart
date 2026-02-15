import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui_kit/ui_kit.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _timezoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const ProfileLoadRequested());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) => previous.profile != current.profile,
        listener: (context, state) {
          final profile = state.profile;
          if (profile != null) {
            _nameController.text = profile.displayName;
            _timezoneController.text = profile.timezone;
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return const LoadingState();
          }

          if (state.error != null && state.profile == null) {
            return ErrorState(
              message: state.error!,
              onRetry: () {
                context.read<ProfileBloc>().add(const ProfileLoadRequested());
              },
            );
          }

          final profile = state.profile;
          if (profile == null) {
            return const EmptyState(
              title: 'Profile not found',
              message: 'Sign in and refresh profile.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppTextField(controller: _nameController, label: 'Display name'),
              const SizedBox(height: 12),
              AppTextField(controller: _timezoneController, label: 'Timezone'),
              const SizedBox(height: 12),
              SwitchListTile(
                value: profile.analyticsOptIn,
                onChanged: (value) {
                  context.read<ProfileBloc>().add(
                    ProfileUpdateRequested(analyticsOptIn: value),
                  );
                },
                title: const Text('Analytics opt-in'),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Save profile',
                isLoading: state.isLoading,
                onPressed: () {
                  context.read<ProfileBloc>().add(
                    ProfileUpdateRequested(
                      displayName: _nameController.text.trim(),
                      timezone: _timezoneController.text.trim(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
