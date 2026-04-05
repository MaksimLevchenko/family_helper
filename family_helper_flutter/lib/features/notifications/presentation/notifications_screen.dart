import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
import '../../../core/routing/app_routes.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/notification_navigation_service.dart';
import '../data/notification_target.dart';
import '../providers/notifications_provider.dart';

part 'notifications_screen_layout.dart';
part 'notifications_screen_widgets.dart';
part 'notifications_screen_helpers.dart';

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
    final target = NotificationOpenTarget.fromAppNotification(notification);
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
          title: Text(context.l10n.notificationsCenterTitle),
          leading: canPop
              ? null
              : IconButton(
                  tooltip: context.l10n.notificationsBackToHome,
                  onPressed: () => _handleBack(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
          showNotificationAction: false,
          actions: [
            IconButton(
              tooltip: context.l10n.notificationsSettingsTooltip,
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
                                  context.l10n.notificationsConnectFamilyTitle,
                              message: context
                                  .l10n
                                  .notificationsConnectFamilyMessage,
                              actionLabel:
                                  context.l10n.notificationsOpenFamilySettings,
                              onAction: () => context.go(AppRoutes.family),
                            ),
                          ),
                        )
                      : isWide
                      ? _buildNotificationsWideLayout(
                          context,
                          state: state,
                          selectedNotification: selectedNotification,
                          filter: _filter,
                          listPaneWidth:
                              _NotificationsScreenState._listPaneWidth,
                          reload: _reload,
                          reloadWithCurrentFilter: () {
                            _reload();
                          },
                          onFilterChanged: (nextFilter) {
                            if (nextFilter == _filter) {
                              return;
                            }
                            setState(() => _filter = nextFilter);
                            _reload();
                          },
                          onWideNotificationTap: _handleWideNotificationTap,
                          onNarrowNotificationTap: _handleNarrowNotificationTap,
                        )
                      : _buildNotificationsNarrowLayout(
                          context,
                          state: state,
                          filter: _filter,
                          reload: _reload,
                          reloadWithCurrentFilter: () {
                            _reload();
                          },
                          onFilterChanged: (nextFilter) {
                            if (nextFilter == _filter) {
                              return;
                            }
                            setState(() => _filter = nextFilter);
                            _reload();
                          },
                          onNarrowNotificationTap: _handleNarrowNotificationTap,
                        );

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
}
