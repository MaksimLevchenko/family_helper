part of 'notifications_screen.dart';

Widget _buildNotificationsNarrowLayout(
  BuildContext context, {
  required NotificationsState state,
  required _InboxFilter filter,
  required Future<void> Function({bool append}) reload,
  required VoidCallback reloadWithCurrentFilter,
  required ValueChanged<_InboxFilter> onFilterChanged,
  required Future<void> Function(AppNotificationDto notification)
  onNarrowNotificationTap,
}) {
  return RefreshIndicator(
    onRefresh: () async {
      await Future.wait<void>([
        reload(),
        context.read<NotificationsCubit>().refreshUnreadCount(),
      ]);
    },
    child: ListView(
      key: const Key('notifications-narrow-layout'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        CachedDataStatus(
          isUsingCachedData: state.isUsingCachedData,
          lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
        ),
        if (state.error != null) ...[
          const SizedBox(height: 12),
          AppBanner(
            text: localizeUiError(context, state.error),
            isError: true,
          ),
        ],
        const SizedBox(height: 12),
        _InboxHero(
          unreadCount: state.unreadCount,
          hasItems: state.inbox.isNotEmpty,
          onMarkAllRead: state.inbox.isEmpty || state.unreadCount == 0
              ? null
              : () => context
                    .read<NotificationsCubit>()
                    .markAllNotificationsRead(),
        ),
        const SizedBox(height: 16),
        _InboxFilterBar(
          filter: filter,
          unreadCount: state.unreadCount,
          onSelectionChanged: onFilterChanged,
        ),
        const SizedBox(height: 16),
        ..._buildNotificationsInboxListContent(
          context,
          state: state,
          filter: filter,
          isWide: false,
          selectedNotificationId: null,
          reload: reload,
          reloadWithCurrentFilter: reloadWithCurrentFilter,
          onFilterChanged: onFilterChanged,
          onWideNotificationTap: (_) async {},
          onNarrowNotificationTap: onNarrowNotificationTap,
        ),
      ],
    ),
  );
}

Widget _buildNotificationsWideLayout(
  BuildContext context, {
  required NotificationsState state,
  required AppNotificationDto? selectedNotification,
  required _InboxFilter filter,
  required double listPaneWidth,
  required Future<void> Function({bool append}) reload,
  required VoidCallback reloadWithCurrentFilter,
  required ValueChanged<_InboxFilter> onFilterChanged,
  required Future<void> Function(AppNotificationDto notification)
  onWideNotificationTap,
  required Future<void> Function(AppNotificationDto notification)
  onNarrowNotificationTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      key: const Key('notifications-wide-layout'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          key: const Key('notifications-list-pane'),
          width: listPaneWidth,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.wait<void>([
                reload(),
                context.read<NotificationsCubit>().refreshUnreadCount(),
              ]);
            },
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                CachedDataStatus(
                  isUsingCachedData: state.isUsingCachedData,
                  lastSuccessfulSyncAt: state.lastSuccessfulSyncAt,
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 12),
                  AppBanner(
                    text: localizeUiError(context, state.error),
                    isError: true,
                  ),
                ],
                const SizedBox(height: 12),
                _InboxHero(
                  unreadCount: state.unreadCount,
                  hasItems: state.inbox.isNotEmpty,
                  onMarkAllRead: state.inbox.isEmpty || state.unreadCount == 0
                      ? null
                      : () => context
                            .read<NotificationsCubit>()
                            .markAllNotificationsRead(),
                ),
                const SizedBox(height: 16),
                _InboxFilterBar(
                  filter: filter,
                  unreadCount: state.unreadCount,
                  onSelectionChanged: onFilterChanged,
                ),
                const SizedBox(height: 16),
                ..._buildNotificationsInboxListContent(
                  context,
                  state: state,
                  filter: filter,
                  isWide: true,
                  selectedNotificationId: selectedNotification?.id,
                  reload: reload,
                  reloadWithCurrentFilter: reloadWithCurrentFilter,
                  onFilterChanged: onFilterChanged,
                  onWideNotificationTap: onWideNotificationTap,
                  onNarrowNotificationTap: onNarrowNotificationTap,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _NotificationDetailPane(
            key: ValueKey<int?>(selectedNotification?.id),
            notification: selectedNotification,
            hasNotifications: state.inbox.isNotEmpty,
          ),
        ),
      ],
    ),
  );
}

List<Widget> _buildNotificationsInboxListContent(
  BuildContext context, {
  required NotificationsState state,
  required _InboxFilter filter,
  required bool isWide,
  required int? selectedNotificationId,
  required Future<void> Function({bool append}) reload,
  required VoidCallback reloadWithCurrentFilter,
  required ValueChanged<_InboxFilter> onFilterChanged,
  required Future<void> Function(AppNotificationDto notification)
  onWideNotificationTap,
  required Future<void> Function(AppNotificationDto notification)
  onNarrowNotificationTap,
}) {
  final showUnreadOnly = filter == _InboxFilter.unread;

  if (state.isLoading && state.inbox.isEmpty) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 32),
        child: LoadingState(label: context.l10n.notificationsLoading),
      ),
    ];
  }

  if (state.inbox.isEmpty) {
    return [
      _NotificationEmptyState(
        icon: showUnreadOnly
            ? Icons.mark_email_read_rounded
            : Icons.notifications_none_rounded,
        title: showUnreadOnly
            ? context.l10n.notificationsNoUnreadTitle
            : context.l10n.notificationsNoItemsTitle,
        message: showUnreadOnly
            ? context.l10n.notificationsNoUnreadMessage
            : context.l10n.notificationsNoItemsMessage,
        actionLabel: showUnreadOnly ? context.l10n.notificationsShowAll : null,
        onAction: showUnreadOnly
            ? () {
                onFilterChanged(_InboxFilter.all);
                reloadWithCurrentFilter();
              }
            : null,
      ),
    ];
  }

  return [
    ...state.inbox.map(
      (notification) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _NotificationTile(
          notification: notification,
          isSelected: isWide && notification.id == selectedNotificationId,
          onTap: () {
            if (isWide) {
              onWideNotificationTap(notification);
              return;
            }
            onNarrowNotificationTap(notification);
          },
        ),
      ),
    ),
    if (state.inboxHasMore)
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: state.isLoading ? null : () => reload(append: true),
          icon: const Icon(Icons.expand_more_rounded),
          label: Text(context.l10n.notificationsLoadMore),
        ),
      ),
  ];
}
