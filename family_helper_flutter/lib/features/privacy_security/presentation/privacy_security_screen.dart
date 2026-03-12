import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              if (profileState.error != null) ...[
                AppBanner(text: profileState.error!, isError: true),
                const SizedBox(height: 12),
              ],
              Card(
                child: SwitchListTile(
                  value: analyticsEnabled,
                  onChanged: profileState.profile == null
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
              Card(
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
                        isLoading: state.isLoading,
                        onPressed: () async {
                          await context.read<PrivacyCubit>().requestExport();
                        },
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Request account deletion',
                        variant: AppButtonVariant.danger,
                        isLoading: state.isLoading,
                        onPressed: () async {
                          await context
                              .read<PrivacyCubit>()
                              .requestAccountDeletion();
                        },
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Cancel deletion request',
                        variant: AppButtonVariant.secondary,
                        onPressed: state.accountDeletion == null
                            ? null
                            : () async {
                                await context
                                    .read<PrivacyCubit>()
                                    .cancelAccountDeletion();
                              },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (state.lastExportJob != null)
                _StatusCard(
                  title: 'Data export',
                  subtitle: _exportSubtitle(state.lastExportJob!),
                  actionLabel: state.lastExportJob!.signedUrl == null
                      ? null
                      : 'Download export',
                  onAction: state.lastExportJob!.signedUrl == null
                      ? null
                      : () async {
                          await _showDownloadDialog(
                            context,
                            state.lastExportJob!.signedUrl!,
                          );
                        },
                ),
              if (state.accountDeletion != null) ...[
                const SizedBox(height: 16),
                _StatusCard(
                  title: 'Account deletion',
                  subtitle: _deletionSubtitle(state.accountDeletion!),
                ),
              ],
              if (state.lastExportJob == null && state.accountDeletion == null)
                const EmptyState(
                  title: 'No active privacy requests',
                  message:
                      'Request an export or account deletion when you need it.',
                ),
            ],
          );
        },
      ),
    );
  }

  String _exportSubtitle(PrivacyExportJobDto exportJob) {
    if (exportJob.signedUrl != null) {
      final expiresAt = exportJob.expiresAt?.toLocal();
      final expiryLabel = expiresAt == null
          ? ''
          : ' Available until $expiresAt.';
      return 'Your export is ready for download.$expiryLabel';
    }
    if (exportJob.completedAt != null) {
      return 'Your export was prepared on ${exportJob.completedAt!.toLocal()}.';
    }
    return 'Status: ${_statusLabel(exportJob.status)}. Requested on ${exportJob.createdAt.toLocal()}.';
  }

  String _deletionSubtitle(AccountDeletionStatusDto deletion) {
    final scheduledAt = deletion.scheduledHardDeleteAt.toLocal();
    if (deletion.status == 'cancelled') {
      return 'The deletion request was cancelled.';
    }
    return 'Status: ${_statusLabel(deletion.status)}. Scheduled for $scheduledAt.';
  }

  String _statusLabel(String status) {
    return switch (status) {
      'requested' => 'Requested',
      'pending' => 'Pending',
      'processing' => 'Processing',
      'scheduled' => 'Scheduled',
      'completed' => 'Completed',
      'cancelled' => 'Cancelled',
      _ => status,
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
