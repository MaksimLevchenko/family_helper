import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/realtime/realtime_provider.dart';
import '../../../core/routing/app_routes.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../notifications/providers/notifications_provider.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RealtimeCubit>().start();
      context.read<NotificationsCubit>().refreshPermissionStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<NotificationsCubit>().refreshPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFamily = context.watch<FamilySelectionCubit>().state != null;
    final location = GoRouterState.of(context).matchedLocation;
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          context.go(
            AppRoutes.locationForTabIndex(value, hasFamily: hasFamily),
          );
        },
        destinations: destinations,
      ),
    );
  }
}
