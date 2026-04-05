import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../ui_kit/app_button.dart';
import '../../../notifications/domain/notification_models.dart';
import '../../../notifications/providers/notifications_provider.dart';

class NotificationAlertCard extends StatelessWidget {
  const NotificationAlertCard({super.key, required this.notifications});

  final NotificationsState notifications;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: scheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    notifications.permissionStatus ==
                            NotificationPermissionStatus.notDetermined
                        ? context.l10n.homeNotificationEnableTitle
                        : context.l10n.homeNotificationBlockedTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notifications.permissionStatus.description(context.l10n),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onTertiaryContainer.withValues(alpha: 0.86),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: notifications.permissionStatus.actionLabel(context.l10n),
              isLoading: notifications.isLoading,
              onPressed: () async {
                final cubit = context.read<NotificationsCubit>();
                if (notifications.permissionStatus ==
                    NotificationPermissionStatus.notDetermined) {
                  await cubit.requestSystemPermission();
                } else {
                  await cubit.openSystemNotificationSettings();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
