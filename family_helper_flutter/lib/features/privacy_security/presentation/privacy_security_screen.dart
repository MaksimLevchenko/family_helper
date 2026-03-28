import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/server_availability_cubit.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../auth_profile/providers/profile_provider.dart';
import '../providers/privacy_provider.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrivacyCubit>().reloadStatus();
      final profileBloc = context.read<ProfileBloc>();
      if (profileBloc.state.profile == null) {
        profileBloc.add(const ProfileLoadRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileBloc>().state;
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    return Scaffold(
      appBar: serverStatusAppBar(context, title: const Text('Privacy')),
      body: BlocBuilder<PrivacyCubit, PrivacyState>(
        builder: (context, state) {
          if (state.isLoading &&
              state.lastExportJob == null &&
              state.accountDeletion == null) {
            return const LoadingState();
          }

          if (state.error != null &&
              state.lastExportJob == null &&
              state.accountDeletion == null) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<PrivacyCubit>().reloadStatus(),
            );
          }

          final analyticsEnabled =
              profileState.profile?.analyticsOptIn ?? false;
          final canRequestDeletion = !state.hasActiveDeletionRequest;

          final privacyControls = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: SwitchListTile(
                  value: analyticsEnabled,
                  onChanged: profileState.profile == null || isOffline
                      ? null
                      : (value) {
                          context.read<ProfileBloc>().add(
                            ProfileUpdateRequested(analyticsOptIn: value),
                          );
                        },
                  title: const Text('Share anonymous analytics'),
                  subtitle: const Text(
                    'Help improve the app with aggregated usage information.',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _DataActionsCard(
                isLoading: state.isLoading,
                canRequestDeletion: canRequestDeletion,
                hasActiveDeletionRequest: state.hasActiveDeletionRequest,
                isOffline: isOffline,
                onRequestExport: () async {
                  await context.read<PrivacyCubit>().requestExport();
                },
                onRequestDeletion: () async {
                  await context.read<PrivacyCubit>().requestAccountDeletion();
                },
                onCancelDeletion: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await context.read<PrivacyCubit>().cancelAccountDeletion();
                  if (!mounted) {
                    return;
                  }
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Deletion request cancelled'),
                    ),
                  );
                },
              ),
            ],
          );

          final statusCards = <Widget>[
            if (state.lastExportJob != null)
              _StatusCard(
                title: 'Data export',
                subtitle: _exportSubtitle(state.lastExportJob!),
                actionLabel: state.canDownloadExport ? 'Download export' : null,
                onAction:
                    !state.canDownloadExport ||
                        state.lastExportJob!.signedUrl == null
                    ? null
                    : () async {
                        await _openDownloadUrl(
                          context,
                          state.lastExportJob!.signedUrl!,
                        );
                      },
              ),
            if (state.shouldShowDeletionCard) ...[
              if (state.lastExportJob != null) const SizedBox(height: 16),
              _StatusCard(
                title: 'Account deletion',
                subtitle: _deletionSubtitle(state.accountDeletion!),
              ),
            ],
            if (!state.hasVisiblePrivacyRequest)
              const EmptyState(
                title: 'No active privacy requests',
                message:
                    'Request an export or account deletion when you need it.',
              ),
          ];

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
                  if (profileState.error != null) ...[
                    AppBanner(text: profileState.error!, isError: true),
                    const SizedBox(height: 12),
                  ],
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: privacyControls),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: statusCards,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    privacyControls,
                    const SizedBox(height: 16),
                    ...statusCards,
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _exportSubtitle(PrivacyExportJobDto exportJob) {
    final expiresAt = exportJob.expiresAt?.toLocal();
    final isExpired =
        exportJob.expiresAt != null &&
        exportJob.expiresAt!.isBefore(DateTime.now().toUtc());
    if (exportJob.signedUrl != null && !isExpired) {
      final expiryLabel = expiresAt == null
          ? ''
          : ' Available until $expiresAt.';
      return 'Export ready.$expiryLabel';
    }
    if (isExpired) {
      return 'Export expired. Request a new data export to generate a fresh link.';
    }
    if (exportJob.status == 'failed') {
      return 'Export failed. Request a new data export to try again.';
    }
    if (exportJob.status == 'pending' || exportJob.status == 'processing') {
      return 'Preparing export. We will make it available when it is ready.';
    }
    return 'Preparing export. Requested on ${exportJob.createdAt.toLocal()}.';
  }

  String _deletionSubtitle(AccountDeletionStatusDto deletion) {
    final scheduledAt = deletion.scheduledHardDeleteAt.toLocal();
    return switch (deletion.status) {
      'requested' ||
      'pending' ||
      'processing' ||
      'scheduled' => 'Deletion scheduled for $scheduledAt.',
      'cancelled' => 'Deletion cancelled.',
      'completed' || 'hard_deleted' => 'Deletion completed.',
      _ => 'Deletion scheduled for $scheduledAt.',
    };
  }

  Future<void> _showDownloadDialog(BuildContext context, String url) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Download export'),
          content: const Text(
            'Use this secure link in your browser to download the export archive.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (!dialogContext.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download link copied')),
                );
              },
              child: const Text('Copy link'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openDownloadUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          return;
        }
      } catch (_) {}
    }

    if (!context.mounted) {
      return;
    }
    await _showDownloadDialog(context, url);
  }
}

class _DataActionsCard extends StatelessWidget {
  const _DataActionsCard({
    required this.isLoading,
    required this.canRequestDeletion,
    required this.hasActiveDeletionRequest,
    required this.isOffline,
    required this.onRequestExport,
    required this.onRequestDeletion,
    required this.onCancelDeletion,
  });

  final bool isLoading;
  final bool canRequestDeletion;
  final bool hasActiveDeletionRequest;
  final bool isOffline;
  final Future<void> Function() onRequestExport;
  final Future<void> Function() onRequestDeletion;
  final Future<void> Function() onCancelDeletion;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Request data export',
              isLoading: isLoading,
              onPressed: () async {
                await onRequestExport();
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Request account deletion',
              variant: AppButtonVariant.danger,
              isLoading: isLoading,
              onPressed: !canRequestDeletion
                  ? null
                  : () async {
                      await onRequestDeletion();
                    },
            ),
            if (hasActiveDeletionRequest) ...[
              const SizedBox(height: 12),
              AppButton(
                label: 'Cancel deletion request',
                variant: AppButtonVariant.secondary,
                onPressed: isOffline
                    ? null
                    : () async {
                        await onCancelDeletion();
                      },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final Future<void> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              AppButton(
                label: actionLabel!,
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  await onAction!();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
