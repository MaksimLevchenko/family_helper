import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui_kit/ui_kit.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.error != null) ...[
                AppBanner(text: state.error!, isError: true),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: 'Reload status',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  await context.read<PrivacyCubit>().reloadStatus();
                },
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
                onPressed: () async {
                  await context.read<PrivacyCubit>().requestAccountDeletion();
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Cancel account deletion',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  await context.read<PrivacyCubit>().cancelAccountDeletion();
                },
              ),
              const SizedBox(height: 24),
              if (state.lastExportJob != null)
                AppTile(
                  title: 'Export job #${state.lastExportJob!.id}',
                  subtitle:
                      'Status: ${state.lastExportJob!.status}, URL: ${state.lastExportJob!.signedUrl ?? '-'}, created: ${state.lastExportJob!.createdAt.toLocal()}',
                ),
              if (state.accountDeletion != null)
                AppTile(
                  title: 'Deletion request #${state.accountDeletion!.id}',
                  subtitle:
                      'Status: ${state.accountDeletion!.status}, scheduled: ${state.accountDeletion!.scheduledHardDeleteAt.toLocal()}',
                ),
              if (state.lastExportJob == null && state.accountDeletion == null)
                const EmptyState(
                  title: 'No privacy operations',
                  message:
                      'Create export or deletion request from this screen.',
                ),
            ],
          );
        },
      ),
    );
  }
}
