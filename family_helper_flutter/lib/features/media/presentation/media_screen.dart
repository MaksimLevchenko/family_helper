import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
import '../../../core/network/server_availability_cubit.dart';
import '../../../ui_kit/ui_kit.dart';
import '../providers/media_provider.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;

    return Scaffold(
      appBar: serverStatusAppBar(
        context,
        title: Text(context.l10n.mediaTitle),
      ),
      body: BlocBuilder<MediaCubit, MediaState>(
        builder: (context, state) {
          if (state.isLoading &&
              state.items.isEmpty &&
              state.lastSignedUrl == null) {
            return const LoadingState();
          }

          if (state.error != null &&
              state.items.isEmpty &&
              state.lastSignedUrl == null) {
            return ErrorState(
              message: localizeUiError(context, state.error),
              onRetry: () => context.read<MediaCubit>().reload(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
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
              AppButton(
                label: context.l10n.mediaReload,
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  await context.read<MediaCubit>().reload();
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: context.l10n.mediaUploadImage,
                isLoading: state.isLoading,
                onPressed: isOffline
                    ? null
                    : () async {
                  await context.read<MediaCubit>().uploadImage();
                },
              ),
              const SizedBox(height: 16),
              if (state.lastSignedUrl == null)
                const SizedBox.shrink()
              else
                AppTile(
                  title: context.l10n.mediaLastMediaId('${state.lastMediaId}'),
                  subtitle: state.lastSignedUrl,
                ),
              const SizedBox(height: 12),
              if (state.items.isEmpty)
                EmptyState(
                  title: context.l10n.mediaEmptyTitle,
                  message: context.l10n.mediaEmptyMessage,
                )
              else
                ...state.items.map(
                  (item) => AppTile(
                    title: context.l10n.mediaItemTitle(item.id),
                    subtitle:
                        'status=${item.status}, mime=${item.mimeType}, size=${item.sizeBytes}, key=${item.objectKey}',
                    trailing: IconButton(
                      onPressed: () async {
                        await context.read<MediaCubit>().softDelete(item.id);
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
