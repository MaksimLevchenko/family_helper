class ProfileForm {
  const ProfileForm({
    required this.displayName,
    required this.timezone,
    required this.analyticsOptIn,
  });

  final String displayName;
  final String timezone;
  final bool analyticsOptIn;
}
