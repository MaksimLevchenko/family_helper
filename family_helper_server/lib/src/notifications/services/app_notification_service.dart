import 'dart:convert';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../generated/protocol.dart';
import 'notification_message_builder.dart';
import 'push_dispatch_service.dart';

class AppNotificationService {
  AppNotificationService({
    AuthContext? authContext,
    ClockService? clock,
    EnsureFamilyRoleService? rbac,
    PushDispatchService? pushDispatch,
  }) : authContext = authContext ?? const AuthContext(),
       clock = clock ?? const ClockService(),
       rbac = rbac ?? const EnsureFamilyRoleService(),
       pushDispatch = pushDispatch ?? PushDispatchService();

  final AuthContext authContext;
  final ClockService clock;
  final EnsureFamilyRoleService rbac;
  final PushDispatchService pushDispatch;

  Future<AppNotificationListResponse> listInbox(
    Session session, {
    required int familyId,
    bool unreadOnly = false,
    int limit = 50,
    DateTime? before,
  }) async {
    final profileId = await rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
    );
    final normalizedLimit = limit <= 0 ? 1 : (limit > 100 ? 100 : limit);
    final rows = await AppNotificationRow.db.find(
      session,
      where: (t) {
        var predicate =
            t.profileId.equals(profileId) & t.familyId.equals(familyId);
        if (unreadOnly) {
          predicate = predicate & t.isRead.equals(false);
        }
        if (before != null) {
          predicate = predicate & (t.createdAt < before.toUtc());
        }
        return predicate;
      },
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: normalizedLimit + 1,
    );

    final hasMore = rows.length > normalizedLimit;
    final items = rows.take(normalizedLimit).map(_mapNotification).toList();
    return AppNotificationListResponse(items: items, hasMore: hasMore);
  }

  Future<OperationResult> markRead(
    Session session, {
    required int notificationId,
  }) async {
    final profileId = await authContext.ensureProfileId(session);
    final row = await AppNotificationRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(notificationId) & t.profileId.equals(profileId),
    );
    if (row == null) {
      throw FileNotFoundException(message: 'Notification not found.');
    }
    if (row.isRead) {
      return OperationResult(success: true, message: 'Already read');
    }
    await AppNotificationRow.db.updateRow(
      session,
      row.copyWith(
        isRead: true,
        readAt: clock.nowUtc(),
        version: row.version + 1,
      ),
    );
    return OperationResult(success: true, message: 'Notification marked read');
  }

  Future<OperationResult> markAllRead(
    Session session, {
    required int familyId,
  }) async {
    final profileId = await rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
    );
    final unreadRows = await AppNotificationRow.db.find(
      session,
      where: (t) =>
          t.profileId.equals(profileId) &
          t.familyId.equals(familyId) &
          t.isRead.equals(false),
    );
    if (unreadRows.isEmpty) {
      return OperationResult(success: true, message: 'No unread notifications');
    }
    final now = clock.nowUtc();
    for (final row in unreadRows) {
      await AppNotificationRow.db.updateRow(
        session,
        row.copyWith(
          isRead: true,
          readAt: now,
          version: row.version + 1,
        ),
      );
    }
    return OperationResult(
      success: true,
      message: 'Marked ${unreadRows.length} notifications as read',
    );
  }

  Future<int> unreadCount(
    Session session, {
    required int familyId,
  }) async {
    final profileId = await rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
    );
    final result = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*)::int AS "count"
      FROM "app_notification"
      WHERE "profileId" = @profileId
        AND "familyId" = @familyId
        AND "isRead" = FALSE
      ''',
      parameters: QueryParameters.named({
        'profileId': profileId,
        'familyId': familyId,
      }),
    );
    if (result.isEmpty) {
      return 0;
    }
    return result.first.toColumnMap()['count'] as int;
  }

  Future<List<int>> listActiveFamilyProfileIds(
    Session session, {
    required int familyId,
    Set<int> excludeProfileIds = const <int>{},
    Transaction? transaction,
  }) async {
    final members = await FamilyMemberRow.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.status.equals('active') &
          t.deletedAt.equals(null),
      transaction: transaction,
    );
    return members
        .map((member) => member.profileId)
        .where((profileId) => !excludeProfileIds.contains(profileId))
        .toSet()
        .toList()
      ..sort();
  }

  Future<List<AppNotificationDto>> createForProfiles(
    Session session, {
    required Iterable<int> profileIds,
    required int familyId,
    required String category,
    required String title,
    required String body,
    required String entityType,
    required int entityId,
    String? route,
    Map<String, dynamic>? payload,
    Transaction? transaction,
  }) async {
    if (profileIds.isEmpty) {
      return const <AppNotificationDto>[];
    }

    final normalizedRoute = defaultNotificationRouteForEntityType(
      entityType,
      explicitRoute: route,
    );
    final normalizedPayload = buildAppNotificationPayload(
      familyId: familyId,
      entityType: entityType,
      entityId: entityId,
      route: normalizedRoute,
      payload: payload,
    );
    final now = clock.nowUtc();
    final insertedRows = <AppNotificationRow>[];
    for (final profileId in profileIds.toSet()) {
      final row = await AppNotificationRow.db.insertRow(
        session,
        AppNotificationRow(
          profileId: profileId,
          familyId: familyId,
          category: category,
          title: title,
          body: body,
          entityType: entityType,
          entityId: entityId,
          route: normalizedRoute,
          payloadJson: jsonEncode(normalizedPayload),
          isRead: false,
          readAt: null,
          createdAt: now,
          pushedAt: null,
          pushStatus: 'pending',
          version: 1,
        ),
        transaction: transaction,
      );
      insertedRows.add(row);
    }

    final resolvedRows = <AppNotificationRow>[];
    for (final row in insertedRows) {
      final updated = await pushDispatch.dispatchForNotification(
        session,
        notification: row,
        transaction: transaction,
      );
      resolvedRows.add(updated);
    }
    return resolvedRows.map(_mapNotification).toList();
  }

  Future<String> profileLocaleCode(
    Session session, {
    required int profileId,
    Transaction? transaction,
  }) async {
    final profile = await AppProfileRow.db.findById(
      session,
      profileId,
      transaction: transaction,
    );
    return normalizeNotificationLocaleCode(profile?.locale);
  }

  Future<List<AppNotificationDto>> createLocalizedForProfiles(
    Session session, {
    required Iterable<int> profileIds,
    required int familyId,
    required String category,
    required NotificationMessage Function(String localeCode, int profileId)
    buildMessage,
    required String entityType,
    required int entityId,
    String? route,
    Map<String, dynamic>? payload,
    Transaction? transaction,
  }) async {
    final normalizedProfileIds = profileIds.toSet().toList()..sort();
    if (normalizedProfileIds.isEmpty) {
      return const <AppNotificationDto>[];
    }

    final profiles = await AppProfileRow.db.find(
      session,
      where: (t) => t.id.inSet(normalizedProfileIds.toSet()),
      transaction: transaction,
    );
    final localeByProfileId = {
      for (final profile in profiles)
        profile.id!: normalizeNotificationLocaleCode(profile.locale),
    };

    final notifications = <AppNotificationDto>[];
    for (final profileId in normalizedProfileIds) {
      final message = buildMessage(
        localeByProfileId[profileId] ?? 'en',
        profileId,
      );
      final created = await createForProfiles(
        session,
        profileIds: [profileId],
        familyId: familyId,
        category: category,
        title: message.title,
        body: message.body,
        entityType: entityType,
        entityId: entityId,
        route: route,
        payload: payload,
        transaction: transaction,
      );
      notifications.addAll(created);
    }
    return notifications;
  }

  Future<List<AppNotificationDto>> createForFamilyMembers(
    Session session, {
    required int familyId,
    Set<int> excludeProfileIds = const <int>{},
    required String category,
    required String title,
    required String body,
    required String entityType,
    required int entityId,
    String? route,
    Map<String, dynamic>? payload,
    Transaction? transaction,
  }) async {
    final profileIds = await listActiveFamilyProfileIds(
      session,
      familyId: familyId,
      excludeProfileIds: excludeProfileIds,
      transaction: transaction,
    );
    return createForProfiles(
      session,
      profileIds: profileIds,
      familyId: familyId,
      category: category,
      title: title,
      body: body,
      entityType: entityType,
      entityId: entityId,
      route: route,
      payload: payload,
      transaction: transaction,
    );
  }

  Future<List<AppNotificationDto>> createLocalizedForFamilyMembers(
    Session session, {
    required int familyId,
    Set<int> excludeProfileIds = const <int>{},
    required String category,
    required NotificationMessage Function(String localeCode, int profileId)
    buildMessage,
    required String entityType,
    required int entityId,
    String? route,
    Map<String, dynamic>? payload,
    Transaction? transaction,
  }) async {
    final profileIds = await listActiveFamilyProfileIds(
      session,
      familyId: familyId,
      excludeProfileIds: excludeProfileIds,
      transaction: transaction,
    );
    return createLocalizedForProfiles(
      session,
      profileIds: profileIds,
      familyId: familyId,
      category: category,
      buildMessage: buildMessage,
      entityType: entityType,
      entityId: entityId,
      route: route,
      payload: payload,
      transaction: transaction,
    );
  }

  AppNotificationDto _mapNotification(AppNotificationRow row) {
    return AppNotificationDto(
      id: row.id!,
      profileId: row.profileId,
      familyId: row.familyId,
      category: row.category,
      title: row.title,
      body: row.body,
      entityType: row.entityType,
      entityId: row.entityId,
      route: row.route,
      payloadJson: row.payloadJson,
      isRead: row.isRead,
      readAt: row.readAt,
      createdAt: row.createdAt,
      pushedAt: row.pushedAt,
      pushStatus: row.pushStatus,
      version: row.version,
    );
  }
}

Map<String, dynamic> buildAppNotificationPayload({
  required int familyId,
  required String entityType,
  required int entityId,
  String? route,
  Map<String, dynamic>? payload,
}) {
  final normalizedRoute = defaultNotificationRouteForEntityType(
    entityType,
    explicitRoute: route,
  );
  return <String, dynamic>{
    ...?payload,
    'familyId': familyId,
    'entityType': entityType,
    'entityId': entityId,
    if (normalizedRoute != null && normalizedRoute.trim().isNotEmpty)
      'route': normalizedRoute,
  };
}

String? defaultNotificationRouteForEntityType(
  String entityType, {
  String? explicitRoute,
}) {
  final trimmedExplicitRoute = explicitRoute?.trim();
  if (trimmedExplicitRoute != null && trimmedExplicitRoute.isNotEmpty) {
    return trimmedExplicitRoute;
  }
  return switch (entityType) {
    'task' => '/home/tasks',
    'calendar' => '/home/calendar',
    'goal' => '/home/goals',
    'list' => '/home/lists',
    'invite' => '/home/settings/family',
    'notification' => '/home/notifications/settings',
    _ => '/home/notifications',
  };
}
