import 'package:get_it/get_it.dart';

import '../../../features/auth_profile/data/profile_repository.dart';
import '../../../features/calendar/data/calendar_repository.dart';
import '../../../features/family_invites/data/family_repository.dart';
import '../../../features/lists/data/lists_repository.dart';
import '../../../features/media/data/media_repository.dart';
import '../../../features/money_goals/data/money_goals_repository.dart';
import '../../../features/notifications/data/notifications_repository.dart';
import '../../../features/privacy_security/data/privacy_repository.dart';
import '../../../features/tasks/data/tasks_repository.dart';

void registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<FamilyRepository>(() => FamilyRepository(getIt()));
  getIt.registerLazySingleton<CalendarRepository>(
    () => CalendarRepository(getIt()),
  );
  getIt.registerLazySingleton<TasksRepository>(() => TasksRepository(getIt()));
  getIt.registerLazySingleton<ListsRepository>(() => ListsRepository(getIt()));
  getIt.registerLazySingleton<MoneyGoalsRepository>(
    () => MoneyGoalsRepository(getIt()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepository(getIt()),
  );
  getIt.registerLazySingleton<MediaRepository>(() => MediaRepository(getIt()));
  getIt.registerLazySingleton<PrivacyRepository>(() => PrivacyRepository(getIt()));
  getIt.registerLazySingleton<ProfileRepositoryContract>(
    () => ProfileRepository(getIt()),
  );
}
