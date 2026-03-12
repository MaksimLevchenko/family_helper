import 'package:get_it/get_it.dart';

import '../network/app_api_client.dart';
import 'modules/app_services_module.dart';
import 'modules/global_state_module.dart';
import 'modules/repositories_module.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (getIt.isRegistered<AppApiClient>()) {
    return;
  }

  await registerAppServices(getIt);
  registerRepositories(getIt);
  await registerGlobalState(getIt);
}

Future<void> resetServiceLocator() async {
  if (!getIt.isRegistered<AppApiClient>()) {
    return;
  }
  await getIt.reset(dispose: true);
}
