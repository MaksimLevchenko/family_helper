part of 'notification_settings_screen.dart';

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.value,
    required this.onChanged,
    required this.title,
    required this.subtitle,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.permissionStatus});

  final NotificationPermissionStatus permissionStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.notificationsTuneTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            permissionStatus.summaryLabel(l10n),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.notificationsTuneSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final showAction =
        state.permissionStatus != NotificationPermissionStatus.granted;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationsSystemTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              state.permissionStatus.description(l10n),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (showAction)
              AppButton(
                label: state.permissionStatus.actionLabel(l10n),
                isLoading: state.isLoading,
                onPressed: () async {
                  final cubit = context.read<NotificationsCubit>();
                  if (state.permissionStatus ==
                      NotificationPermissionStatus.notDetermined) {
                    await cubit.requestSystemPermission();
                  } else {
                    await cubit.openSystemNotificationSettings();
                  }
                },
              )
            else
              Text(l10n.notificationsEnabled),
          ],
        ),
      ),
    );
  }
}

class _DebugToolsCard extends StatelessWidget {
  const _DebugToolsCard({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationsDebugTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.notificationsDebugSubtitle,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: l10n.notificationsSendTestPush,
              isLoading: state.isLoading,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final result = await context
                    .read<NotificationsCubit>()
                    .scheduleDebugNotification();
                if (!context.mounted || result.message == null) {
                  return;
                }
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(result.message!)),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
