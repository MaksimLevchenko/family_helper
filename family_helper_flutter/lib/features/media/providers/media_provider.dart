import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_error_classifier.dart';
import '../../../core/offline/offline_operation.dart';
import '../../../core/offline/offline_queue_manager.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/media_repository.dart';

class MediaState {
  const MediaState({
    this.lastMediaId,
    this.lastSignedUrl,
    required this.items,
    this.isLoading = false,
    this.error,
  });

  final int? lastMediaId;
  final String? lastSignedUrl;
  final List<MediaObjectDto> items;
  final bool isLoading;
  final String? error;

  MediaState copyWith({
    int? lastMediaId,
    String? lastSignedUrl,
    List<MediaObjectDto>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MediaState(
      lastMediaId: lastMediaId ?? this.lastMediaId,
      lastSignedUrl: lastSignedUrl ?? this.lastSignedUrl,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MediaCubit extends Cubit<MediaState> {
  MediaCubit({
    required MediaRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required OfflineQueueManager offlineQueueManager,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _offlineQueueManager = offlineQueueManager,
       super(const MediaState(items: [])) {
    _familySub = _familySelectionCubit.stream.listen((_) {
      unawaited(_handleFamilyChanged());
    });
  }

  final MediaRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final OfflineQueueManager _offlineQueueManager;
  StreamSubscription<int?>? _familySub;
  static const _offlineFeature = 'media';
  static const _actionSoftDelete = 'soft_delete';

  void reset() {
    emit(const MediaState(items: []));
  }

  Future<void> _handleFamilyChanged() async {
    reset();
    await reload();
  }

  Future<void> reload() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final familyId = _familySelectionCubit.state;
    try {
      await _replayQueuedOperations();
      final items = await _repository.listMedia(familyId: familyId);
      emit(
        state.copyWith(
          isLoading: false,
          items: items,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'media.reload',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

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
      await reload();
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

  Future<int?> uploadAvatar() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final media = await _repository.pickCropUpload(familyId: null);
      if (media == null) {
        emit(state.copyWith(isLoading: false));
        return null;
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
      return media.id;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'media.uploadAvatar',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
      return null;
    }
  }

  Future<String> loadSignedUrl(int mediaId) {
    return _repository.signedGetUrl(mediaId);
  }

  Future<void> softDelete(int mediaId) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      await _repository.softDelete(
        clientOperationId: clientOperationId,
        mediaId: mediaId,
      );
      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'media.softDelete',
        error: error,
        stackTrace: stackTrace,
        context: {'mediaId': mediaId},
      );
      if (isOfflineRecoverableError(error)) {
        await _offlineQueueManager.enqueue(
          OfflineOperation(
            id: OperationId.next(),
            feature: _offlineFeature,
            action: _actionSoftDelete,
            payload: {
              'clientOperationId': clientOperationId,
              'mediaId': mediaId,
            },
            createdAt: DateTime.now().toUtc(),
            attempt: 0,
          ),
        );
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Network unavailable. Delete request queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> _replayQueuedOperations() {
    return _offlineQueueManager.replayWhere(
      (operation) async {
        if (operation.action != _actionSoftDelete) {
          return;
        }
        await _repository.softDelete(
          clientOperationId: operation.payload['clientOperationId'] as String,
          mediaId: operation.payload['mediaId'] as int,
        );
      },
      canProcess: (operation) => operation.feature == _offlineFeature,
    );
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
