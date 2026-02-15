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
          if (state.isLoading && state.lastSignedUrl == null) {
            return const LoadingState();
          }

          if (state.error != null && state.lastSignedUrl == null) {
            return ErrorState(
              message: state.error!,
              onRetry: () => context.read<MediaCubit>().uploadImage(),
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
                label: 'Pick, crop and upload image',
                isLoading: state.isLoading,
                onPressed: () async {
                  await context.read<MediaCubit>().uploadImage();
                },
              ),
              const SizedBox(height: 16),
              if (state.lastSignedUrl == null)
                const EmptyState(
                  title: 'No uploaded image',
                  message: 'Upload an image to receive signed GET URL.',
                )
              else
                AppTile(
                  title: 'Last media id: ${state.lastMediaId}',
                  subtitle: state.lastSignedUrl,
                ),
            ],
          );
        },
      ),
    );
  }
}
