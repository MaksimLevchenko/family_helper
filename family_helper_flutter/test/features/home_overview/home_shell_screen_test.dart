import 'package:family_helper_flutter/core/realtime/realtime_provider.dart';
import 'package:family_helper_flutter/core/routing/app_routes.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:family_helper_flutter/features/home_overview/presentation/home_shell_screen.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _RealtimeCubitStub extends Cubit<RealtimeState> implements RealtimeCubit {
  _RealtimeCubitStub() : super(RealtimeState.initial());

  @override
  Future<void> start() async {
    emit(state.copyWith(started: true));
  }
}

class _NotificationsCubitStub extends Cubit<NotificationsState>
    implements NotificationsCubit {
  _NotificationsCubitStub() : super(NotificationsState.initial());

  @override
  Future<ReminderActionResult> ensureReminder({
    required String notificationType,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async => ReminderActionResult.successResult;

  @override
  bool isPreferenceEnabled(String notificationType) => false;

  @override
  Future<void> loadPreferences() async {}

  @override
  Future<bool> openSystemNotificationSettings() async => true;

  @override
  Future<NotificationPermissionStatus> requestSystemPermission() async {
    return state.permissionStatus;
  }

  @override
  Future<NotificationPermissionStatus> requestSystemPermissionIfNeeded() async {
    return state.permissionStatus;
  }

  @override
  Future<void> refreshPermissionStatus() async {}

  @override
  Future<void> registerPushToken({
    required String token,
    String? platform,
  }) async {}

  @override
  Future<void> reloadReminders({String? status}) async {}

  @override
  Future<ReminderActionResult> replaceEntityReminder({
    required String notificationType,
    required String entityType,
    required int entityId,
    DateTime? remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async => ReminderActionResult.successResult;

  @override
  void reset({bool preserveAccountSettings = false}) {
    emit(NotificationsState.initial());
  }

  @override
  Future<ReminderActionResult> scheduleReminder({
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async => ReminderActionResult.successResult;

  @override
  Future<bool> setPreference({
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) async => true;
}

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  _TestFamilySelectionCubit(int? initialFamilyId) : super() {
    emit(initialFamilyId);
  }

  @override
  Future<void> bootstrap() async {}
}

Widget _buildSubject({
  required int? familyId,
  required String initialLocation,
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomeShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.overview,
            builder: (context, state) =>
                const Scaffold(body: Text('Home page')),
          ),
          GoRoute(
            path: AppRoutes.calendar,
            builder: (context, state) =>
                const Scaffold(body: Text('Calendar page')),
          ),
          GoRoute(
            path: AppRoutes.tasks,
            builder: (context, state) =>
                const Scaffold(body: Text('Tasks page')),
          ),
          GoRoute(
            path: AppRoutes.lists,
            builder: (context, state) =>
                const Scaffold(body: Text('Lists page')),
          ),
          GoRoute(
            path: AppRoutes.goals,
            builder: (context, state) =>
                const Scaffold(body: Text('Goals page')),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) =>
                const Scaffold(body: Text('Settings page')),
          ),
        ],
      ),
    ],
  );

  return MultiBlocProvider(
    providers: [
      BlocProvider<FamilySelectionCubit>(
        create: (_) => _TestFamilySelectionCubit(familyId),
      ),
      BlocProvider<RealtimeCubit>(create: (_) => _RealtimeCubitStub()),
      BlocProvider<NotificationsCubit>(
        create: (_) => _NotificationsCubitStub(),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows only Home and Settings destinations without a family', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSubject(familyId: null, initialLocation: AppRoutes.overview),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Calendar'), findsNothing);
    expect(find.text('Tasks'), findsNothing);
    expect(find.text('Lists'), findsNothing);
    expect(find.text('Goals'), findsNothing);
  });

  testWidgets('shows all family destinations when a family is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSubject(familyId: 42, initialLocation: AppRoutes.calendar),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Lists'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
