import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_helper_client/family_helper_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
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
      appBar: serverStatusAppBar(
        context,
        title: Text(context.l10n.settingsPrivacyTitle),
      ),
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
              message: localizeUiError(context, state.error),
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
                  title: Text(context.l10n.privacyAnalyticsTitle),
                  subtitle: Text(context.l10n.privacyAnalyticsSubtitle),
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
                  final cancelledMessage =
                      context.l10n.privacyDeletionCancelled;
                  await context.read<PrivacyCubit>().cancelAccountDeletion();
                  if (!mounted) {
                    return;
                  }
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(cancelledMessage),
                    ),
                  );
                },
              ),
            ],
          );

          final statusCards = <Widget>[
            if (state.lastExportJob != null)
              _StatusCard(
                title: context.l10n.privacyDataExportTitle,
                subtitle: _exportSubtitle(context, state.lastExportJob!),
                actionLabel: state.canDownloadExport
                    ? context.l10n.privacyDownloadExport
                    : null,
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
                title: context.l10n.privacyAccountDeletionTitle,
                subtitle: _deletionSubtitle(context, state.accountDeletion!),
              ),
            ],
            if (!state.hasVisiblePrivacyRequest)
              EmptyState(
                title: context.l10n.privacyNoRequestsTitle,
                message: context.l10n.privacyNoRequestsMessage,
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
                    AppBanner(
                      text: localizeUiError(context, state.error),
                      isError: true,
                    ),
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

  String _exportSubtitle(BuildContext context, PrivacyExportJobDto exportJob) {
    final expiresAt = exportJob.expiresAt?.toLocal();
    final isExpired =
        exportJob.expiresAt != null &&
        exportJob.expiresAt!.isBefore(DateTime.now().toUtc());
    if (exportJob.signedUrl != null && !isExpired) {
      final expiryLabel = expiresAt == null
          ? ''
          : ' ${context.l10n.privacyAvailableUntil(expiresAt.toString())}';
      return '${context.l10n.settingsExportReady}.$expiryLabel';
    }
    if (isExpired) {
      return context.l10n.privacyExportExpiredMessage;
    }
    if (exportJob.status == 'failed') {
      return context.l10n.privacyExportFailedMessage;
    }
    if (exportJob.status == 'pending' || exportJob.status == 'processing') {
      return context.l10n.privacyPreparingExportMessage;
    }
    return context.l10n.privacyPreparingExportRequestedOn(
      exportJob.createdAt.toLocal().toString(),
    );
  }

  String _deletionSubtitle(
    BuildContext context,
    AccountDeletionStatusDto deletion,
  ) {
    final scheduledAt = deletion.scheduledHardDeleteAt.toLocal();
    return switch (deletion.status) {
      'requested' ||
      'pending' ||
      'processing' ||
      'scheduled' => context.l10n.privacyDeletionScheduledFor(
        scheduledAt.toString(),
      ),
      'cancelled' => context.l10n.privacyDeletionCancelled,
      'completed' || 'hard_deleted' => context.l10n.privacyDeletionCompleted,
      _ => context.l10n.privacyDeletionScheduledFor(scheduledAt.toString()),
    };
  }

  Future<void> _showDownloadDialog(BuildContext context, String url) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.privacyDownloadExport),
          content: Text(context.l10n.privacyDownloadDialogMessage),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (!dialogContext.mounted) {
                  return;
                }
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.privacyDownloadLinkCopied),
                  ),
                );
              },
              child: Text(context.l10n.privacyCopyLink),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(context.l10n.commonClose),
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
              context.l10n.privacyYourDataTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.privacyRequestExport,
              isLoading: isLoading,
              onPressed: () async {
                await onRequestExport();
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: context.l10n.privacyRequestDeletion,
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
                label: context.l10n.privacyCancelDeletionRequest,
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
