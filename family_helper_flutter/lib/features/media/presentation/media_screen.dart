import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ui_kit/ui_kit.dart';
import '../providers/media_provider.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media & Avatars')),
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
              message: state.error!,
              onRetry: () => context.read<MediaCubit>().reload(),
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
                label: 'Reload media',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  await context.read<MediaCubit>().reload();
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Pick, crop and upload image',
                isLoading: state.isLoading,
                onPressed: () async {
                  await context.read<MediaCubit>().uploadImage();
                },
              ),
              const SizedBox(height: 16),
              if (state.lastSignedUrl == null)
                const SizedBox.shrink()
              else
                AppTile(
                  title: 'Last media id: ${state.lastMediaId}',
                  subtitle: state.lastSignedUrl,
                ),
              const SizedBox(height: 12),
              if (state.items.isEmpty)
                const EmptyState(
                  title: 'No media objects',
                  message: 'Upload an image to populate media history.',
                )
              else
                ...state.items.map(
                  (item) => AppTile(
                    title: 'Media #${item.id}',
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
