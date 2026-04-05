part of 'notifications_screen.dart';

class _InboxFilterBar extends StatelessWidget {
  const _InboxFilterBar({
    required this.filter,
    required this.unreadCount,
    required this.onSelectionChanged,
  });

  final _InboxFilter filter;
  final int unreadCount;
  final ValueChanged<_InboxFilter> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedButton<_InboxFilter>(
      segments: [
        ButtonSegment<_InboxFilter>(
          value: _InboxFilter.all,
          icon: Icon(Icons.inbox_rounded),
          label: Text(l10n.notificationsFilterAll),
        ),
        ButtonSegment<_InboxFilter>(
          value: _InboxFilter.unread,
          icon: unreadCount > 0
              ? Badge.count(
                  count: unreadCount > 99 ? 99 : unreadCount,
                  child: const Icon(Icons.mark_email_unread_rounded),
                )
              : const Icon(Icons.mark_email_unread_outlined),
          label: Text(l10n.notificationsFilterUnread),
        ),
      ],
      selected: {filter},
      onSelectionChanged: (selection) {
        onSelectionChanged(selection.first);
      },
    );
  }
}

class _InboxHero extends StatelessWidget {
  const _InboxHero({
    required this.unreadCount,
    required this.hasItems,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final bool hasItems;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = unreadCount > 0
        ? l10n.notificationsHeroUnread(unreadCount)
        : (hasItems
              ? l10n.notificationsHeroAllRead
              : l10n.notificationsHeroReady);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primaryContainer,
            scheme.surfaceContainerHighest,
            scheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  unreadCount > 0
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.notificationsHeroTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      status,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.notificationsHeroSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onMarkAllRead,
            icon: const Icon(Icons.done_all_rounded),
            label: Text(l10n.notificationsMarkAllRead),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
    this.isSelected = false,
  });

  final AppNotificationDto notification;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tone = _toneFor(context, notification);
    final backgroundColor = isSelected
        ? tone.$2.withValues(alpha: notification.isRead ? 0.75 : 1)
        : (notification.isRead ? scheme.surfaceContainerHigh : tone.$2);
    final borderColor = isSelected
        ? scheme.primary
        : (notification.isRead
              ? scheme.outlineVariant
              : tone.$4.withValues(alpha: 0.28));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? tone.$2.withValues(alpha: 0.55)
                        : tone.$2,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(tone.$1, color: tone.$4),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.w700
                                    : FontWeight.w800,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(top: 6, left: 8),
                              decoration: BoxDecoration(
                                color: tone.$4,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MetaChip(
                            label: _categoryLabel(
                              context,
                              notification.category,
                            ),
                            color: tone.$4,
                            background: tone.$4.withValues(alpha: 0.12),
                          ),
                          _MetaChip(
                            label: _timestampLabel(
                              context,
                              notification.createdAt,
                            ),
                            color: scheme.onSurfaceVariant,
                            background: scheme.surface,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationDetailPane extends StatelessWidget {
  const _NotificationDetailPane({
    super.key,
    required this.notification,
    required this.hasNotifications,
  });

  final AppNotificationDto? notification;
  final bool hasNotifications;

  @override
  Widget build(BuildContext context) {
    if (notification == null) {
      return _NotificationDetailPlaceholder(
        title: hasNotifications
            ? context.l10n.notificationsDetailSelect
            : context.l10n.notificationsDetailPlaceholderTitle,
        message: hasNotifications
            ? context.l10n.notificationsDetailSelectMessage
            : context.l10n.notificationsDetailPlaceholderMessage,
        icon: hasNotifications
            ? Icons.touch_app_rounded
            : Icons.notifications_none_rounded,
      );
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tone = _toneFor(context, notification!);
    final target = NotificationOpenTarget.fromAppNotification(notification!);

    return Card(
      key: const Key('notifications-detail-pane'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: tone.$2,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(tone.$1, color: tone.$4, size: 30),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaChip(
                  label: _categoryLabel(context, notification!.category),
                  color: tone.$4,
                  background: tone.$4.withValues(alpha: 0.12),
                ),
                _MetaChip(
                  label: notification!.isRead
                      ? context.l10n.notificationsRead
                      : context.l10n.notificationsUnread,
                  color: notification!.isRead
                      ? scheme.onSurfaceVariant
                      : scheme.primary,
                  background: notification!.isRead
                      ? scheme.surfaceContainerHighest
                      : scheme.primaryContainer,
                ),
                _MetaChip(
                  label: _timestampLabel(context, notification!.createdAt),
                  color: scheme.onSurfaceVariant,
                  background: scheme.surfaceContainerHighest,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              notification!.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              notification!.body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            if (target != null)
              FilledButton.icon(
                onPressed: () async {
                  await NotificationNavigationService.openTarget(
                    context,
                    target,
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(_detailActionLabel(context, target)),
              )
            else
              Text(
                context.l10n.notificationsDetailNoTarget,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationDetailPlaceholder extends StatelessWidget {
  const _NotificationDetailPlaceholder({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(icon, color: scheme.primary, size: 34),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotificationEmptyState extends StatelessWidget {
  const _NotificationEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: scheme.primary, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 18),
                FilledButton.tonal(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
