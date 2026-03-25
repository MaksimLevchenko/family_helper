import 'package:flutter_test/flutter_test.dart';

import 'package:family_helper_flutter/core/routing/app_routes.dart';

void main() {
  test('AppRoutes maps full-tab locations to bottom navigation indices', () {
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.overview, hasFamily: true),
      0,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.calendar, hasFamily: true),
      1,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.tasks, hasFamily: true),
      2,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.lists, hasFamily: true),
      3,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.goals, hasFamily: true),
      4,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.settings, hasFamily: true),
      5,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.profile, hasFamily: true),
      5,
    );
  });

  test('AppRoutes maps minimal-tab locations to bottom navigation indices', () {
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.overview, hasFamily: false),
      0,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.settings, hasFamily: false),
      1,
    );
    expect(
      AppRoutes.bottomNavIndexFor(AppRoutes.profile, hasFamily: false),
      1,
    );
  });

  test('AppRoutes returns overview for invalid tab indices', () {
    expect(
      AppRoutes.locationForTabIndex(-1, hasFamily: false),
      AppRoutes.overview,
    );
    expect(
      AppRoutes.locationForTabIndex(99, hasFamily: false),
      AppRoutes.overview,
    );
    expect(
      AppRoutes.locationForTabIndex(-1, hasFamily: true),
      AppRoutes.overview,
    );
    expect(
      AppRoutes.locationForTabIndex(99, hasFamily: true),
      AppRoutes.overview,
    );
  });

  test('AppRoutes flags family-restricted locations', () {
    expect(AppRoutes.isFamilyRestrictedLocation(AppRoutes.calendar), isTrue);
    expect(AppRoutes.isFamilyRestrictedLocation(AppRoutes.tasks), isTrue);
    expect(AppRoutes.isFamilyRestrictedLocation(AppRoutes.lists), isTrue);
    expect(AppRoutes.isFamilyRestrictedLocation(AppRoutes.goals), isTrue);
    expect(AppRoutes.isFamilyRestrictedLocation(AppRoutes.overview), isFalse);
    expect(AppRoutes.isFamilyRestrictedLocation(AppRoutes.settings), isFalse);
  });
}
