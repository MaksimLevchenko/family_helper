import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/notification_navigation_service.dart';
import '../data/push_notification_service.dart';
import '../providers/notifications_provider.dart';

enum _InboxFilter { all, unread }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const double _wideLayoutBreakpoint = 720.0;
  static const double _maxWidthBreakpoint = 1100.0;
  static const double _maxContentWidth = 1280.0;
  static const double _listPaneWidth = 420.0;

  _InboxFilter _filter = _InboxFilter.all;
  int? _selectedNotificationId;

  bool get _showUnreadOnly => _filter == _InboxFilter.unread;

  bool _canPopFromNotificationCenter(BuildContext context) {
    return GoRouter.of(context).canPop();
  }

  void _handleBack(BuildContext context) {
    final goRouter = GoRouter.of(context);
    if (goRouter.canPop()) {
      context.pop();
      return;
    }
    goRouter.go(AppRoutes.overview);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<NotificationsCubit>();
      cubit.refreshUnreadCount();
      cubit.reloadInbox(unreadOnly: _showUnreadOnly);
    });
  }

  Future<void> _reload({bool append = false}) {
    return context.read<NotificationsCubit>().reloadInbox(
      unreadOnly: _showUnreadOnly,
      append: append,
    );
  }

  void _syncSelectedNotification(List<AppNotificationDto> inbox) {
    final nextSelectedId = _nextSelectedNotificationId(inbox);
    if (nextSelectedId == _selectedNotificationId || !mounted) {
      return;
    }
    setState(() => _selectedNotificationId = nextSelectedId);
  }

  int? _nextSelectedNotificationId(List<AppNotificationDto> inbox) {
    if (inbox.isEmpty) {
      return null;
    }
    if (_selectedNotificationId != null &&
        inbox.any(
          (notification) => notification.id == _selectedNotificationId,
        )) {
      return _selectedNotificationId;
    }
    return inbox.first.id;
  }

  AppNotificationDto? _selectedNotification(List<AppNotificationDto> inbox) {
    final selectedId = _nextSelectedNotificationId(inbox);
    if (selectedId == null) {
      return null;
    }
    for (final notification in inbox) {
      if (notification.id == selectedId) {
        return notification;
      }
    }
    return null;
  }

  Future<void> _handleNarrowNotificationTap(
    AppNotificationDto notification,
  ) async {
    final cubit = context.read<NotificationsCubit>();
    if (!notification.isRead) {
      await cubit.markNotificationRead(notification.id);
    }
    if (!mounted) {
      return;
    }
    final target = NotificationOpenTarget.fromPayloadJson(
      notification.payloadJson,
    );
    if (target != null) {
      await NotificationNavigationService.openTarget(context, target);
    }
  }

  Future<void> _handleWideNotificationTap(
    AppNotificationDto notification,
  ) async {
    if (_selectedNotificationId != notification.id) {
      setState(() => _selectedNotificationId = notification.id);
    }

    if (notification.isRead) {
      return;
    }

    await context.read<NotificationsCubit>().markNotificationRead(
      notification.id,
    );
    if (!mounted || !_showUnreadOnly) {
      return;
    }
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final familyId = context.watch<FamilySelectionCubit?>()?.state;
    final canPop = _canPopFromNotificationCenter(context);

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && mounted) {
          GoRouter.of(context).go(AppRoutes.overview);
        }
      },
      child: Scaffold(
        appBar: serverStatusAppBar(
          context,
          title: const Text('Notifications'),
          leading: canPop
              ? null
              : IconButton(
                  tooltip: 'Back to home',
                  onPressed: () => _handleBack(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
          showNotificationAction: false,
          actions: [
            IconButton(
              tooltip: 'Notification settings',
              onPressed: () => context.push(AppRoutes.notificationSettings),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
              final maxWidth = constraints.maxWidth >= _maxWidthBreakpoint
                  ? _maxContentWidth
                  : double.infinity;

              return BlocConsumer<NotificationsCubit, NotificationsState>(
                listener: (context, state) {
                  _syncSelectedNotification(state.inbox);
                },
                builder: (context, state) {
                  final selectedNotification = _selectedNotification(
                    state.inbox,
                  );

                  final content = familyId == null
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: _NotificationEmptyState(
                              icon: Icons.notifications_paused_rounded,
                              title:
                                  'Connect a family to start receiving updates',
                              message:
                                  'Your dedicated notification center will light up with reminders, invites, and activity once you join a family.',
                              actionLabel: 'Open family settings',
                              onAction: () => context.go(AppRoutes.family),
                            ),
                          ),
                        )
                      : isWide
                      ? _buildWideLayout(
                          context,
                          state: state,
                          selectedNotification: selectedNotification,
                        )
                      : _buildNarrowLayout(context, state: state);

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: content,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(
    BuildContext context, {
    required NotificationsState state,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait<void>([
          _reload(),
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
            AppBanner(text: state.error!, isError: true),
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
            filter: _filter,
            unreadCount: state.unreadCount,
            onSelectionChanged: (nextFilter) {
              if (nextFilter == _filter) {
                return;
              }
              setState(() => _filter = nextFilter);
              _reload();
            },
          ),
          const SizedBox(height: 16),
          ..._buildInboxListContent(
            context,
            state: state,
            isWide: false,
            selectedNotificationId: null,
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(
    BuildContext context, {
    required NotificationsState state,
    required AppNotificationDto? selectedNotification,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        key: const Key('notifications-wide-layout'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            key: const Key('notifications-list-pane'),
            width: _listPaneWidth,
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait<void>([
                  _reload(),
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
                    AppBanner(text: state.error!, isError: true),
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
                    filter: _filter,
                    unreadCount: state.unreadCount,
                    onSelectionChanged: (nextFilter) {
                      if (nextFilter == _filter) {
                        return;
                      }
                      setState(() => _filter = nextFilter);
                      _reload();
                    },
                  ),
                  const SizedBox(height: 16),
                  ..._buildInboxListContent(
                    context,
                    state: state,
                    isWide: true,
                    selectedNotificationId: selectedNotification?.id,
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

  List<Widget> _buildInboxListContent(
    BuildContext context, {
    required NotificationsState state,
    required bool isWide,
    required int? selectedNotificationId,
  }) {
    if (state.isLoading && state.inbox.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: LoadingState(label: 'Loading notifications...'),
        ),
      ];
    }

    if (state.inbox.isEmpty) {
      return [
        _NotificationEmptyState(
          icon: _showUnreadOnly
              ? Icons.mark_email_read_rounded
              : Icons.notifications_none_rounded,
          title: _showUnreadOnly
              ? 'No unread notifications'
              : 'No notifications yet',
          message: _showUnreadOnly
              ? 'Everything in your family inbox has already been opened.'
              : 'New reminders and family activity will show up here as soon as they arrive.',
          actionLabel: _showUnreadOnly ? 'Show all notifications' : null,
          onAction: _showUnreadOnly
              ? () {
                  setState(() => _filter = _InboxFilter.all);
                  _reload();
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
                _handleWideNotificationTap(notification);
                return;
              }
              _handleNarrowNotificationTap(notification);
            },
          ),
        ),
      ),
      if (state.inboxHasMore)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: state.isLoading ? null : () => _reload(append: true),
            icon: const Icon(Icons.expand_more_rounded),
            label: const Text('Load more'),
          ),
        ),
    ];
  }
}

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
    return SegmentedButton<_InboxFilter>(
      segments: [
        const ButtonSegment<_InboxFilter>(
          value: _InboxFilter.all,
          icon: Icon(Icons.inbox_rounded),
          label: Text('All'),
        ),
        ButtonSegment<_InboxFilter>(
          value: _InboxFilter.unread,
          icon: unreadCount > 0
              ? Badge.count(
                  count: unreadCount > 99 ? 99 : unreadCount,
                  child: const Icon(Icons.mark_email_unread_rounded),
                )
              : const Icon(Icons.mark_email_unread_outlined),
          label: const Text('Unread'),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = unreadCount > 0
        ? '$unreadCount unread'
        : (hasItems ? 'Everything is read' : 'Ready for new updates');

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
                      'Family inbox',
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
            'A dedicated place for reminders, updates, and family activity that deserves attention.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onMarkAllRead,
            icon: const Icon(Icons.done_all_rounded),
            label: const Text('Mark all read'),
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
                            label: _categoryLabel(notification.category),
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
            ? 'Select a notification'
            : 'Your notification details will appear here',
        message: hasNotifications
            ? 'Choose any update from the inbox to see the full message and related action.'
            : 'Once new reminders or family activity arrive, you will be able to review the full context here.',
        icon: hasNotifications
            ? Icons.touch_app_rounded
            : Icons.notifications_none_rounded,
      );
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tone = _toneFor(context, notification!);
    final target = NotificationOpenTarget.fromPayloadJson(
      notification!.payloadJson,
    );

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
                  label: _categoryLabel(notification!.category),
                  color: tone.$4,
                  background: tone.$4.withValues(alpha: 0.12),
                ),
                _MetaChip(
                  label: notification!.isRead ? 'Read' : 'Unread',
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
                label: Text(_detailActionLabel(target)),
              )
            else
              Text(
                'This update does not include a linked destination, but the full message is preserved here for reference.',
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

String _timestampLabel(BuildContext context, DateTime createdAt) {
  final localizations = MaterialLocalizations.of(context);
  final local = createdAt.toLocal();
  final date = localizations.formatShortDate(local);
  final time = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: true,
  );
  return '$date, $time';
}

String _categoryLabel(String category) {
  return switch (category) {
    'due_reminder' => 'Reminder',
    'task_assigned' => 'Assigned task',
    'task_completed' => 'Completed task',
    'calendar_created' => 'Calendar update',
    'calendar_updated' => 'Calendar update',
    'calendar_cancelled' => 'Calendar cancelled',
    'family_invite_created' => 'Family invite',
    'family_invite_accepted' => 'Family update',
    'debug_test_push' => 'Test push',
    _ => 'Notification',
  };
}

String _detailActionLabel(NotificationOpenTarget target) {
  return switch (target.entityType) {
    'task' => 'Open task',
    'calendar' => 'Open calendar',
    'list' => 'Open list',
    'goal' => 'Open goal',
    _ => 'Open notification',
  };
}

(IconData, Color, Color, Color) _toneFor(
  BuildContext context,
  AppNotificationDto notification,
) {
  final scheme = Theme.of(context).colorScheme;
  return switch (notification.category) {
    'due_reminder' => (
      Icons.alarm_rounded,
      scheme.primaryContainer,
      scheme.onPrimaryContainer,
      scheme.primary,
    ),
    'task_assigned' || 'task_completed' => (
      Icons.task_alt_rounded,
      scheme.secondaryContainer,
      scheme.onSecondaryContainer,
      scheme.onSecondaryContainer,
    ),
    'calendar_created' || 'calendar_updated' || 'calendar_cancelled' => (
      Icons.event_rounded,
      scheme.tertiaryContainer,
      scheme.onTertiaryContainer,
      scheme.onTertiaryContainer,
    ),
    'family_invite_created' || 'family_invite_accepted' => (
      Icons.groups_2_rounded,
      scheme.primaryContainer,
      scheme.onPrimaryContainer,
      scheme.onPrimaryContainer,
    ),
    'debug_test_push' => (
      Icons.bug_report_rounded,
      scheme.errorContainer,
      scheme.onErrorContainer,
      scheme.onErrorContainer,
    ),
    _ => (
      switch (notification.entityType) {
        'task' => Icons.check_circle_outline_rounded,
        'calendar' => Icons.calendar_today_rounded,
        'goal' => Icons.savings_rounded,
        'list' => Icons.list_alt_rounded,
        _ => Icons.notifications_rounded,
      },
      scheme.surfaceContainerHighest,
      scheme.onSurface,
      scheme.primary,
    ),
  };
}
