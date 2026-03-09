import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../auth/auth_session.dart';
import '../../theme/theme_controller.dart';

void registerGlobalState(GetIt getIt) {
  getIt.registerSingleton<ThemeCubit>(
    ThemeCubit(),
    dispose: (cubit) => cubit.close(),
  );

  final authCubit = AuthCubit(getIt());
  getIt.registerSingleton<AuthCubit>(
    authCubit,
    dispose: (cubit) => cubit.close(),
  );

  unawaited(authCubit.bootstrap());
}
