import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../auth/auth_session.dart';
import '../../theme/theme_controller.dart';

Future<void> registerGlobalState(GetIt getIt) async {
  final themeCubit = ThemeCubit();
  await themeCubit.bootstrap();

  getIt.registerSingleton<ThemeCubit>(
    themeCubit,
    dispose: (cubit) => cubit.close(),
  );

  final authCubit = AuthCubit(getIt());
  getIt.registerSingleton<AuthCubit>(
    authCubit,
    dispose: (cubit) => cubit.close(),
  );

  unawaited(authCubit.bootstrap());
}
