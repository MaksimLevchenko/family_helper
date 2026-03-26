import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/offline/in_memory_offline_snapshot_store.dart';
import 'package:family_helper_flutter/features/auth_profile/data/profile_repository.dart';
import 'package:family_helper_flutter/features/auth_profile/providers/profile_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProfileRepository implements ProfileRepositoryContract {
  _FakeProfileRepository({
    required this.onMe,
    this.onUpdate,
  });

  final Future<ProfileDto> Function() onMe;
  final Future<ProfileDto> Function({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool clearAvatarMedia,
    bool? analyticsOptIn,
  })?
  onUpdate;

  @override
  Future<ProfileDto> me() => onMe();

  @override
  Future<ProfileDto> update({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool clearAvatarMedia = false,
    bool? analyticsOptIn,
  }) {
    final handler = onUpdate;
    if (handler == null) {
      throw UnimplementedError();
    }
    return handler(
      clientOperationId: clientOperationId,
      displayName: displayName,
      timezone: timezone,
      avatarMediaId: avatarMediaId,
      clearAvatarMedia: clearAvatarMedia,
      analyticsOptIn: analyticsOptIn,
    );
  }
}

void main() {
  test(
    'restores cached profile and keeps it when a reload fails',
    () async {
      final snapshotStore = InMemoryOfflineSnapshotStore();
      await snapshotStore.init();
      final cachedProfile = _profileDto(
        id: 42,
        displayName: 'Cached User',
        updatedAt: DateTime.utc(2026, 3, 26, 9),
      );
      final cachedAt = DateTime.utc(2026, 3, 26, 9, 5);
      await snapshotStore.write('profile/current', {
        'profile': cachedProfile.toJson(),
      }, updatedAt: cachedAt);

      final bloc = ProfileBloc(
        repository: _FakeProfileRepository(
          onMe: () async => throw Exception('network unavailable'),
        ),
        snapshotStore: snapshotStore,
      );

      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.profile?.id, cachedProfile.id);
      expect(bloc.state.isUsingCachedData, isTrue);
      expect(bloc.state.lastSuccessfulSyncAt, cachedAt);

      bloc.add(const ProfileLoadRequested());
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.profile?.displayName, 'Cached User');
      expect(bloc.state.isUsingCachedData, isTrue);
      expect(bloc.state.error, contains('network unavailable'));

      await bloc.close();
    },
  );

  test('successful load updates the snapshot timestamp and fresh state', () async {
    final snapshotStore = InMemoryOfflineSnapshotStore();
    await snapshotStore.init();
    final freshProfile = _profileDto(
      id: 7,
      displayName: 'Fresh User',
      updatedAt: DateTime.utc(2026, 3, 26, 12),
    );
    final bloc = ProfileBloc(
      repository: _FakeProfileRepository(onMe: () async => freshProfile),
      snapshotStore: snapshotStore,
    );

    await Future<void>.delayed(Duration.zero);
    bloc.add(const ProfileLoadRequested());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final snapshot = await snapshotStore.read('profile/current');

    expect(bloc.state.profile?.displayName, 'Fresh User');
    expect(bloc.state.isUsingCachedData, isFalse);
    expect(bloc.state.lastSuccessfulSyncAt, isNotNull);
    expect(snapshot, isNotNull);
    expect(
      ProfileDto.fromJson(snapshot!.payload['profile']! as Map<String, dynamic>)
          .displayName,
      'Fresh User',
    );

    await bloc.close();
  });
}

ProfileDto _profileDto({
  required int id,
  required String displayName,
  required DateTime updatedAt,
}) {
  return ProfileDto(
    id: id,
    authUserId: 'auth-$id',
    displayName: displayName,
    timezone: 'Europe/Moscow',
    analyticsOptIn: true,
    createdAt: updatedAt.subtract(const Duration(days: 1)),
    updatedAt: updatedAt,
  );
}
