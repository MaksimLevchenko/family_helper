import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/realtime/realtime_provider.dart';
import '../../../core/routing/app_routes.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../notifications/data/notification_navigation_service.dart';
import '../../notifications/data/push_notification_service.dart';
import '../../notifications/providers/notifications_provider.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen>
    with WidgetsBindingObserver {
  StreamSubscription<NotificationOpenTarget>? _notificationOpenSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RealtimeCubit>().start();
      context.read<NotificationsCubit>().refreshPermissionStatus();
      context.read<NotificationsCubit>().refreshUnreadCount();
      if (getIt.isRegistered<PushNotificationService>()) {
        _notificationOpenSub = getIt<PushNotificationService>().openTargets
            .listen(
              (target) {
                unawaited(_openNotificationTarget(target));
              },
            );
        final initialTarget = getIt<PushNotificationService>()
            .takePendingInitialOpen();
        if (initialTarget != null) {
          unawaited(_openNotificationTarget(initialTarget));
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_notificationOpenSub?.cancel());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<NotificationsCubit>().refreshPermissionStatus();
      context.read<NotificationsCubit>().refreshUnreadCount();
    }
  }

  Future<void> _openNotificationTarget(NotificationOpenTarget target) async {
    if (!mounted) {
      return;
    }
    if (target.notificationId != null) {
      await context.read<NotificationsCubit>().markNotificationRead(
        target.notificationId!,
      );
    }
    if (!mounted) {
      return;
    }
    await NotificationNavigationService.openTarget(context, target);
  }

  @override
  Widget build(BuildContext context) {
    final hasFamily = context.watch<FamilySelectionCubit>().state != null;
    final location = GoRouterState.of(context).matchedLocation;
    final showBottomNavigation = !location.startsWith(
      AppRoutes.notificationCenter,
    );
    final selectedIndex = AppRoutes.bottomNavIndexFor(
      location,
      hasFamily: hasFamily,
    );
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      ),
      if (hasFamily) ...const [
        NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calendar',
        ),
        NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
        NavigationDestination(icon: Icon(Icons.list_alt), label: 'Lists'),
        NavigationDestination(
          icon: Icon(Icons.savings_outlined),
          label: 'Goals',
        ),
      ],
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        label: 'Settings',
      ),
    ];

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: showBottomNavigation
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                context.go(
                  AppRoutes.locationForTabIndex(value, hasFamily: hasFamily),
                );
              },
              destinations: destinations,
            )
          : null,
    );
  }
}
