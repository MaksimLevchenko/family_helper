import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/network/server_availability_cubit.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../calendar/providers/calendar_provider.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../lists/providers/lists_provider.dart';
import '../../media/providers/media_provider.dart';
import '../../money_goals/providers/money_goals_provider.dart';
import '../../tasks/providers/tasks_provider.dart';
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
  ProfileDto? _lastAppliedProfile;
  _PendingProfileRefresh? _pendingProfileRefresh;

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
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    return Scaffold(
      appBar: serverStatusAppBar(
        context,
        title: Text(context.l10n.profileTitle),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) {
          final hasProfileChanged = previous.profile != current.profile;
          final hasPendingUpdateErrorChanged =
              _pendingProfileRefresh != null && previous.error != current.error;
          return hasProfileChanged || hasPendingUpdateErrorChanged;
        },
        listener: (context, state) {
          if (state.error != null && !state.isLoading) {
            _pendingProfileRefresh = null;
          }

          final profile = state.profile;
          if (profile != null) {
            final previousAppliedProfile = _lastAppliedProfile;
            _applyProfile(profile);
            final pendingRefresh = _pendingProfileRefresh;
            if (pendingRefresh != null && previousAppliedProfile != null) {
              final identityChanged = _hasIdentityChanged(
                previousAppliedProfile,
                profile,
              );
              final timezoneChanged = _hasTimezoneChanged(
                previousAppliedProfile,
                profile,
              );
              final shouldRefreshDependents =
                  (pendingRefresh.affectsIdentity && identityChanged) ||
                  (pendingRefresh.affectsTimezone && timezoneChanged);

              if (shouldRefreshDependents) {
                unawaited(
                  _refreshDependentData(reloadCalendar: timezoneChanged),
                );
              }
            }
            _pendingProfileRefresh = null;
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
            return EmptyState(
              title: context.l10n.profileNotFoundTitle,
              message: context.l10n.profileNotFoundMessage,
            );
          }

          final avatarCard = _AvatarCard(
            avatarMediaId: profile.avatarMediaId,
            avatarUrlFuture: _avatarUrlFuture,
            isLoading: mediaState.isLoading || state.isLoading,
            onChangePhoto: isOffline
                ? null
                : () async {
                    final mediaCubit = context.read<MediaCubit>();
                    final profileBloc = context.read<ProfileBloc>();
                    final mediaId = await mediaCubit.uploadAvatar();
                    if (!mounted || mediaId == null) {
                      return;
                    }
                    _pendingProfileRefresh = const _PendingProfileRefresh(
                      affectsIdentity: true,
                    );
                    profileBloc.add(
                      ProfileUpdateRequested(avatarMediaId: mediaId),
                    );
                  },
            onRemovePhoto: isOffline || profile.avatarMediaId == null
                ? null
                : () {
                    _pendingProfileRefresh = const _PendingProfileRefresh(
                      affectsIdentity: true,
                    );
                    context.read<ProfileBloc>().add(
                      const ProfileUpdateRequested(clearAvatarMedia: true),
                    );
                  },
          );

          final detailsSection = _ProfileDetailsSection(
            nameController: _nameController,
            selectedTimezone: _selectedTimezone ?? 'UTC',
            isOffline: isOffline,
            isLoading: state.isLoading,
            timezones: _timezones,
            onTimezoneChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedTimezone = value;
              });
            },
            onSave: () {
              _pendingProfileRefresh = const _PendingProfileRefresh(
                affectsIdentity: true,
                affectsTimezone: true,
              );
              context.read<ProfileBloc>().add(
                ProfileUpdateRequested(
                  displayName: _nameController.text.trim(),
                  timezone: _selectedTimezone ?? 'UTC',
                ),
              );
            },
          );

          return ResponsiveContentLayout(
            builder: (context, isWide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CachedDataStatus(
                    isUsingCachedData: state.isUsingCachedData,
                    lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
                  ),
                  if (state.error != null) ...[
                    AppBanner(text: state.error!, isError: true),
                    const SizedBox(height: 12),
                  ],
                  if (mediaState.error != null) ...[
                    AppBanner(text: mediaState.error!, isError: true),
                    const SizedBox(height: 12),
                  ],
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: avatarCard),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: _ProfileFormCard(child: detailsSection),
                        ),
                      ],
                    )
                  else ...[
                    avatarCard,
                    const SizedBox(height: 16),
                    detailsSection,
                  ],
                ],
              );
            },
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
    _lastAppliedProfile = profile;
  }

  bool _hasIdentityChanged(ProfileDto previous, ProfileDto next) {
    return previous.displayName != next.displayName ||
        previous.avatarMediaId != next.avatarMediaId;
  }

  bool _hasTimezoneChanged(ProfileDto previous, ProfileDto next) {
    return previous.timezone != next.timezone;
  }

  Future<void> _refreshDependentData({required bool reloadCalendar}) async {
    final reloads = <Future<void>>[
      context.read<FamilyMembersCubit>().loadMembers(),
      context.read<TasksCubit>().reload(),
      context.read<ListsCubit>().reload(),
      context.read<MoneyGoalsCubit>().reload(),
    ];
    if (reloadCalendar) {
      reloads.add(context.read<CalendarCubit>().reload());
    }
    await Future.wait(reloads);
  }
}

class _PendingProfileRefresh {
  const _PendingProfileRefresh({
    this.affectsIdentity = false,
    this.affectsTimezone = false,
  });

  final bool affectsIdentity;
  final bool affectsTimezone;
}

class _ProfileFormCard extends StatelessWidget {
  const _ProfileFormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _ProfileDetailsSection extends StatelessWidget {
  const _ProfileDetailsSection({
    required this.nameController,
    required this.selectedTimezone,
    required this.isOffline,
    required this.isLoading,
    required this.timezones,
    required this.onTimezoneChanged,
    required this.onSave,
  });

  final TextEditingController nameController;
  final String selectedTimezone;
  final bool isOffline;
  final bool isLoading;
  final List<String> timezones;
  final ValueChanged<String?> onTimezoneChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: nameController,
          label: l10n.profileDisplayNameLabel,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: ValueKey(selectedTimezone),
          initialValue: selectedTimezone,
          decoration: InputDecoration(labelText: l10n.profileTimezoneLabel),
          items: timezones
              .map(
                (timezone) => DropdownMenuItem<String>(
                  value: timezone,
                  child: Text(timezone),
                ),
              )
              .toList(),
          onChanged: isOffline ? null : onTimezoneChanged,
        ),
        const SizedBox(height: 16),
        AppButton(
          label: l10n.profileSave,
          isLoading: isLoading,
          onPressed: isOffline ? null : onSave,
        ),
      ],
    );
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
  final Future<void> Function()? onChangePhoto;
  final VoidCallback? onRemovePhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              avatarMediaId == null
                  ? l10n.profileNoPhotoYet
                  : l10n.profilePhoto,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.profilePhotoHint,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: avatarMediaId == null
                  ? l10n.profileAddPhoto
                  : l10n.profileChangePhoto,
              isLoading: isLoading,
              onPressed: onChangePhoto == null
                  ? null
                  : () async {
                      await onChangePhoto!();
                    },
            ),
            if (onRemovePhoto != null) ...[
              const SizedBox(height: 12),
              AppButton(
                label: l10n.profileRemovePhoto,
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
