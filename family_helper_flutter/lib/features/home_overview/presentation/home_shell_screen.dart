import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/realtime/realtime_provider.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../lists/presentation/lists_screen.dart';
import '../../money_goals/presentation/money_goals_screen.dart';
import '../../tasks/presentation/tasks_screen.dart';
import 'home_overview_screen.dart';
import 'settings_screen.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _index = 0;

  final _screens = const [
    HomeOverviewScreen(),
    CalendarScreen(),
    TasksScreen(),
    ListsScreen(),
    MoneyGoalsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RealtimeCubit>().start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
          ),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Lists'),
          NavigationDestination(icon: Icon(Icons.savings_outlined), label: 'Goals'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
