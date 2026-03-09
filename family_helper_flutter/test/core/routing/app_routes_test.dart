import 'package:flutter_test/flutter_test.dart';

import 'package:family_helper_flutter/core/routing/app_routes.dart';

void main() {
  test('AppRoutes maps locations to bottom navigation indices', () {
    expect(AppRoutes.bottomNavIndexFor(AppRoutes.overview), 0);
    expect(AppRoutes.bottomNavIndexFor(AppRoutes.calendar), 1);
    expect(AppRoutes.bottomNavIndexFor(AppRoutes.tasks), 2);
    expect(AppRoutes.bottomNavIndexFor(AppRoutes.lists), 3);
    expect(AppRoutes.bottomNavIndexFor(AppRoutes.goals), 4);
    expect(AppRoutes.bottomNavIndexFor(AppRoutes.settings), 5);
    expect(AppRoutes.bottomNavIndexFor(AppRoutes.profile), 5);
  });

  test('AppRoutes returns overview for invalid tab indices', () {
    expect(AppRoutes.locationForTabIndex(-1), AppRoutes.overview);
    expect(AppRoutes.locationForTabIndex(99), AppRoutes.overview);
  });
}
