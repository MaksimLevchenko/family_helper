import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';

import '../../../ui_kit/ui_kit.dart';
import '../../media/providers/media_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _timezones = <String>[
    'UTC',
    'Europe/Moscow',
    'Europe/Berlin',
    'Europe/London',
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'Asia/Dubai',
    'Asia/Almaty',
    'Asia/Bangkok',
    'Asia/Singapore',
    'Asia/Tokyo',
    'Australia/Sydney',
  ];

  final _nameController = TextEditingController();
  String? _selectedTimezone;
  Future<String>? _avatarUrlFuture;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile != null) {
      _applyProfile(profile);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const ProfileLoadRequested());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = context.watch<MediaCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) => previous.profile != current.profile,
        listener: (context, state) {
          final profile = state.profile;
          if (profile != null) {
            _applyProfile(profile);
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
              if (mediaState.error != null) ...[
                AppBanner(text: mediaState.error!, isError: true),
                const SizedBox(height: 12),
              ],
              _AvatarCard(
                avatarMediaId: profile.avatarMediaId,
                avatarUrlFuture: _avatarUrlFuture,
                isLoading: mediaState.isLoading || state.isLoading,
                onChangePhoto: () async {
                  final mediaCubit = context.read<MediaCubit>();
                  final profileBloc = context.read<ProfileBloc>();
                  final mediaId = await mediaCubit.uploadAvatar();
                  if (!mounted || mediaId == null) {
                    return;
                  }
                  profileBloc.add(
                    ProfileUpdateRequested(avatarMediaId: mediaId),
                  );
                },
                onRemovePhoto: profile.avatarMediaId == null
                    ? null
                    : () {
                        context.read<ProfileBloc>().add(
                          const ProfileUpdateRequested(clearAvatarMedia: true),
                        );
                      },
              ),
              const SizedBox(height: 16),
              AppTextField(controller: _nameController, label: 'Display name'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey(_selectedTimezone ?? 'UTC'),
                initialValue: _selectedTimezone ?? 'UTC',
                decoration: const InputDecoration(labelText: 'Timezone'),
                items: _timezones
                    .map(
                      (timezone) => DropdownMenuItem<String>(
                        value: timezone,
                        child: Text(timezone),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedTimezone = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Save profile',
                isLoading: state.isLoading,
                onPressed: () {
                  context.read<ProfileBloc>().add(
                    ProfileUpdateRequested(
                      displayName: _nameController.text.trim(),
                      timezone: _selectedTimezone ?? 'UTC',
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

  void _applyProfile(ProfileDto profile) {
    _nameController.text = profile.displayName;
    _selectedTimezone = _timezones.contains(profile.timezone)
        ? profile.timezone
        : 'UTC';
    _avatarUrlFuture = profile.avatarMediaId == null
        ? null
        : context.read<MediaCubit>().loadSignedUrl(profile.avatarMediaId!);
  }
}

class _AvatarCard extends StatelessWidget {
  const _AvatarCard({
    required this.avatarMediaId,
    required this.avatarUrlFuture,
    required this.isLoading,
    required this.onChangePhoto,
    required this.onRemovePhoto,
  });

  final int? avatarMediaId;
  final Future<String>? avatarUrlFuture;
  final bool isLoading;
  final Future<void> Function() onChangePhoto;
  final VoidCallback? onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: avatarUrlFuture,
              builder: (context, snapshot) {
                final imageUrl = snapshot.data;
                return CircleAvatar(
                  radius: 36,
                  backgroundImage: imageUrl == null
                      ? null
                      : NetworkImage(imageUrl),
                  child: imageUrl == null
                      ? const Icon(Icons.person_outline, size: 32)
                      : null,
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              avatarMediaId == null ? 'No profile photo yet' : 'Profile photo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Use a clear photo so family members can recognize you easily.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: avatarMediaId == null ? 'Add photo' : 'Change photo',
              isLoading: isLoading,
              onPressed: () async {
                await onChangePhoto();
              },
            ),
            if (onRemovePhoto != null) ...[
              const SizedBox(height: 12),
              AppButton(
                label: 'Remove photo',
                variant: AppButtonVariant.secondary,
                isLoading: isLoading,
                onPressed: onRemovePhoto,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
