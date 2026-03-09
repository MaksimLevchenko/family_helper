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
  static const media = '/home/settings/media';
  static const privacy = '/home/settings/privacy';

  static const tabLocations = <String>[
    overview,
    calendar,
    tasks,
    lists,
    goals,
    settings,
  ];

  static int bottomNavIndexFor(String location) {
    if (location == calendar) return 1;
    if (location == tasks) return 2;
    if (location == lists) return 3;
    if (location == goals) return 4;
    if (location.startsWith(settings)) return 5;
    return 0;
  }

  static String locationForTabIndex(int index) {
    if (index < 0 || index >= tabLocations.length) {
      return overview;
    }
    return tabLocations[index];
  }
}
