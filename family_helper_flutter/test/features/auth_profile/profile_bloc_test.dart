import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:family_helper_flutter/features/auth_profile/data/profile_repository.dart';
import 'package:family_helper_flutter/features/auth_profile/providers/profile_provider.dart';

class FakeProfileRepository implements ProfileRepositoryContract {
  FakeProfileRepository(this._profile);

  ProfileDto _profile;

  @override
  Future<ProfileDto> me() async => _profile;

  @override
  Future<ProfileDto> update({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
  }) async {
    _profile = _profile.copyWith(
      displayName: displayName ?? _profile.displayName,
      timezone: timezone ?? _profile.timezone,
      avatarMediaId: avatarMediaId ?? _profile.avatarMediaId,
      analyticsOptIn: analyticsOptIn ?? _profile.analyticsOptIn,
    );
    return _profile;
  }
}

void main() {
  test('ProfileBloc loads and updates profile', () async {
    final repository = FakeProfileRepository(
      ProfileDto(
        id: 1,
        authUserId: '00000000-0000-4000-8000-000000000001',
        displayName: 'Initial',
        timezone: 'UTC',
        analyticsOptIn: false,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final bloc = ProfileBloc(repository: repository);

    bloc.add(const ProfileLoadRequested());
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(bloc.state.profile?.displayName, 'Initial');

    bloc.add(
      const ProfileUpdateRequested(
        displayName: 'Updated',
        analyticsOptIn: true,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(bloc.state.profile?.displayName, 'Updated');
    expect(bloc.state.profile?.analyticsOptIn, true);

    bloc.add(const ProfileResetRequested());
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(bloc.state.profile, isNull);
    expect(bloc.state.isLoading, true);

    await bloc.close();
  });
}
