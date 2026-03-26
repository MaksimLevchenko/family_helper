import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/auth/auth_session.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FamilySelectionCubit', () {
    late FlutterSecureStorage storage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storage = const FlutterSecureStorage();
    });

    test(
      'bootstrap restores the family from the server for authenticated user',
      () async {
        const cachedFamilyId = 11;
        final authState = _MutableAuthState(
          const AuthSessionState(
            isInitializing: false,
            isAuthenticated: true,
          ),
        );
        await storage.write(
          key: 'current_family_id',
          value: '$cachedFamilyId',
        );

        var loadCount = 0;
        final cubit = FamilySelectionCubit(
          storage: storage,
          authStates: const Stream<AuthSessionState>.empty(),
          authStateProvider: authState.current,
          loadCurrentFamily: () async {
            loadCount += 1;
            return _family(id: 42, title: 'Recovered family');
          },
        );

        await cubit.bootstrap();

        expect(loadCount, 1);
        expect(cubit.state, 42);
        expect(await storage.read(key: 'current_family_id'), '42');

        await cubit.close();
      },
    );

    test(
      'bootstrap clears stale local family when the server returns null',
      () async {
        await storage.write(key: 'current_family_id', value: '77');
        final authState = _MutableAuthState(
          const AuthSessionState(
            isInitializing: false,
            isAuthenticated: true,
          ),
        );

        final cubit = FamilySelectionCubit(
          storage: storage,
          authStates: const Stream<AuthSessionState>.empty(),
          authStateProvider: authState.current,
          loadCurrentFamily: () async => null,
        );

        await cubit.bootstrap();

        expect(cubit.state, isNull);
        expect(await storage.read(key: 'current_family_id'), isNull);

        await cubit.close();
      },
    );

    test('authenticated transition restores family after bootstrap', () async {
      final authController = StreamController<AuthSessionState>.broadcast();
      final authState = _MutableAuthState(
        const AuthSessionState(
          isInitializing: false,
          isAuthenticated: false,
        ),
      );

      final cubit = FamilySelectionCubit(
        storage: storage,
        authStates: authController.stream,
        authStateProvider: authState.current,
        loadCurrentFamily: () async => _family(id: 55, title: 'Login family'),
      );

      await cubit.bootstrap();
      expect(cubit.state, isNull);

      authState.value = const AuthSessionState(
        isInitializing: false,
        isAuthenticated: true,
      );
      authController.add(authState.value);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, 55);
      expect(await storage.read(key: 'current_family_id'), '55');

      await authController.close();
      await cubit.close();
    });
  });
}

class _MutableAuthState {
  _MutableAuthState(this.value);

  AuthSessionState value;

  AuthSessionState current() => value;
}

FamilyDto _family({
  required int id,
  required String title,
}) {
  return FamilyDto(
    id: id,
    title: title,
    ownerProfileId: 1,
    memberLimit: 2,
    createdAt: DateTime.utc(2026, 3, 26),
    updatedAt: DateTime.utc(2026, 3, 26),
  );
}
