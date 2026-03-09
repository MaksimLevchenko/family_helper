import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/media_repository.dart';

class MediaState {
  const MediaState({
    this.lastMediaId,
    this.lastSignedUrl,
    this.isLoading = false,
    this.error,
  });

  final int? lastMediaId;
  final String? lastSignedUrl;
  final bool isLoading;
  final String? error;

  MediaState copyWith({
    int? lastMediaId,
    String? lastSignedUrl,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MediaState(
      lastMediaId: lastMediaId ?? this.lastMediaId,
      lastSignedUrl: lastSignedUrl ?? this.lastSignedUrl,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MediaCubit extends Cubit<MediaState> {
  MediaCubit({
    required MediaRepository repository,
    required FamilySelectionCubit familySelectionCubit,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       super(const MediaState());

  final MediaRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;

  Future<void> uploadImage() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final media = await _repository.pickCropUpload(
        familyId: _familySelectionCubit.state,
      );
      if (media == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final signedUrl = await _repository.signedGetUrl(media.id);
      emit(
        state.copyWith(
          isLoading: false,
          lastMediaId: media.id,
          lastSignedUrl: signedUrl,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'media.uploadImage',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': _familySelectionCubit.state},
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }
}
