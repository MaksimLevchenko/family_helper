class AppRoutes {
  const AppRoutes._();

  static const loading = '/loading';
  static const signIn = '/sign-in';
  static const registerEmail = '/register/email';
  static const registerCode = '/register/code';
  static const registerPassword = '/register/password';

  static const overview = '/home';
  static const calendar = '/home/calendar';
  static const tasks = '/home/tasks';
  static const lists = '/home/lists';
  static const goals = '/home/goals';
  static const settings = '/home/settings';

  static const profile = '/home/settings/profile';
  static const family = '/home/settings/family';
  static const localReminders = '/home/settings/local-reminders';
  static const privacy = '/home/settings/privacy';

  static const _fullTabLocations = <String>[
    overview,
    calendar,
    tasks,
    lists,
    goals,
    settings,
  ];

  static const _minimalTabLocations = <String>[overview, settings];

  static bool isFamilyRestrictedLocation(String location) {
    return location == calendar ||
        location == tasks ||
        location == lists ||
        location == goals;
  }

  static int bottomNavIndexFor(String location, {required bool hasFamily}) {
    final tabLocation = _tabLocationForLocation(location);
    final tabLocations = _tabLocationsFor(hasFamily: hasFamily);
    final index = tabLocations.indexOf(tabLocation);
    return index == -1 ? 0 : index;
  }

  static String locationForTabIndex(int index, {required bool hasFamily}) {
    final tabLocations = _tabLocationsFor(hasFamily: hasFamily);
    if (index < 0 || index >= tabLocations.length) {
      return overview;
    }
    return tabLocations[index];
  }

  static List<String> _tabLocationsFor({required bool hasFamily}) {
    return hasFamily ? _fullTabLocations : _minimalTabLocations;
  }

  static String _tabLocationForLocation(String location) {
    if (location.startsWith(settings)) {
      return settings;
    }
    if (_fullTabLocations.contains(location)) {
      return location;
    }
    return overview;
  }
}
