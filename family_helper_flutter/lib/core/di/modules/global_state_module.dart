import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../auth/auth_session.dart';
import '../../l10n/locale_controller.dart';
import '../../offline/offline_snapshot_store.dart';
import '../../network/server_availability_cubit.dart';
import '../../theme/theme_controller.dart';

Future<void> registerGlobalState(GetIt getIt) async {
  final localeCubit = LocaleCubit();
  await localeCubit.bootstrap();

  getIt.registerSingleton<LocaleCubit>(
    localeCubit,
    dispose: (cubit) => cubit.close(),
  );

  final themeCubit = ThemeCubit();
  await themeCubit.bootstrap();

  getIt.registerSingleton<ThemeCubit>(
    themeCubit,
    dispose: (cubit) => cubit.close(),
  );

  final authCubit = AuthCubit(getIt(), snapshotStore: getIt<OfflineSnapshotStore>());
  getIt.registerSingleton<AuthCubit>(
    authCubit,
    dispose: (cubit) => cubit.close(),
  );

  final serverAvailabilityCubit = ServerAvailabilityCubit(getIt());
  getIt.registerSingleton<ServerAvailabilityCubit>(
    serverAvailabilityCubit,
    dispose: (cubit) => cubit.close(),
  );

  unawaited(authCubit.bootstrap());
}
