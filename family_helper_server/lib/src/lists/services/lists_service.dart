import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class ListsService {
  ListsService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;

  Future<FamilyListDto> upsertList(
    Session session, {
    required String clientOperationId,
    int? listId,
    required int familyId,
    required String title,
    required String listType,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.upsertList',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh && listId != null) {
        return _findList(session, listId, transaction: transaction);
      }

      final now = DateTime.now().toUtc();
      if (listId == null) {
        final inserted = await session.db.unsafeQuery(
          '''
          INSERT INTO family_list (
            family_id,
            title,
            list_type,
            created_by_profile_id,
            created_at,
            updated_at,
            deleted_at,
            version
          ) VALUES (
            @familyId,
            @title,
            @listType,
            @createdBy,
            @now,
            @now,
            NULL,
            1
          )
          RETURNING
            id,
            family_id,
            title,
            list_type,
            created_by_profile_id,
            updated_at,
            version
          ''',
          parameters: QueryParameters.named({
            'familyId': familyId,
            'title': title,
            'listType': listType,
            'createdBy': profileId,
            'now': now,
          }),
          transaction: transaction,
        );
        final dto = _mapList(inserted.first.toColumnMap());
        await _emitListChange(
          session,
          familyId: familyId,
          entityType: 'list',
          entityId: dto.id,
          transaction: transaction,
        );
        return dto;
      }

      await session.db.unsafeExecute(
        '''
        UPDATE family_list
        SET title = @title,
            list_type = @listType,
            updated_at = @updatedAt,
            version = version + 1
        WHERE id = @id
          AND family_id = @familyId
          AND deleted_at IS NULL
        ''',
        parameters: QueryParameters.named({
          'id': listId,
          'familyId': familyId,
          'title': title,
          'listType': listType,
          'updatedAt': now,
        }),
        transaction: transaction,
      );

      final updated = await _findList(session, listId, transaction: transaction);
      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list',
        entityId: updated.id,
        transaction: transaction,
      );
      return updated;
    });
  }

  Future<ListItemDto> addItem(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int listId,
    required String title,
    double qty = 1,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.addItem',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        final latest = await session.db.unsafeQuery(
          '''
          SELECT
            id,
            list_id,
            title,
            qty,
            unit,
            note,
            price_cents,
            category,
            position_index,
            is_bought,
            bought_by_profile_id,
            bought_at,
            updated_at,
            version
          FROM list_item
          WHERE list_id = @listId
            AND deleted_at IS NULL
          ORDER BY id DESC
          LIMIT 1
          ''',
          parameters: QueryParameters.named({'listId': listId}),
          transaction: transaction,
        );
        if (latest.isNotEmpty) {
          return _mapItem(latest.first.toColumnMap());
        }
      }

      final now = DateTime.now().toUtc();
      final positionResult = await session.db.unsafeQuery(
        'SELECT COALESCE(MAX(position_index), 0) + 1 AS next_position FROM list_item WHERE list_id = @listId',
        parameters: QueryParameters.named({'listId': listId}),
        transaction: transaction,
      );
      final nextPosition = positionResult.first.toColumnMap()['next_position'] as int;

      final inserted = await session.db.unsafeQuery(
        '''
        INSERT INTO list_item (
          list_id,
          title,
          qty,
          unit,
          note,
          price_cents,
          category,
          position_index,
          is_bought,
          bought_by_profile_id,
          bought_at,
          created_by_profile_id,
          created_at,
          updated_at,
          deleted_at,
          version
        ) VALUES (
          @listId,
          @title,
          @qty,
          @unit,
          @note,
          @priceCents,
          @category,
          @position,
          false,
          NULL,
          NULL,
          @createdBy,
          @now,
          @now,
          NULL,
          1
        )
        RETURNING
          id,
          list_id,
          title,
          qty,
          unit,
          note,
          price_cents,
          category,
          position_index,
          is_bought,
          bought_by_profile_id,
          bought_at,
          updated_at,
          version
        ''',
        parameters: QueryParameters.named({
          'listId': listId,
          'title': title,
          'qty': qty,
          'unit': unit,
          'note': note,
          'priceCents': priceCents,
          'category': category,
          'position': nextPosition,
          'createdBy': actorProfileId,
          'now': now,
        }),
        transaction: transaction,
      );

      final item = _mapItem(inserted.first.toColumnMap());
      await _appendItemHistory(
        session,
        itemId: item.id,
        actorProfileId: actorProfileId,
        eventType: 'created',
        transaction: transaction,
      );

      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list_item',
        entityId: item.id,
        transaction: transaction,
      );

      return item;
    });
  }

  Future<ListItemDto> toggleBought(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.toggleBought',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final locked = await session.db.unsafeQuery(
        '''
        SELECT
          li.id,
          li.list_id,
          li.title,
          li.qty,
          li.unit,
          li.note,
          li.price_cents,
          li.category,
          li.position_index,
          li.is_bought,
          li.bought_by_profile_id,
          li.bought_at,
          li.updated_at,
          li.version,
          fl.family_id
        FROM list_item li
        JOIN family_list fl ON fl.id = li.list_id
        WHERE li.id = @itemId
          AND li.deleted_at IS NULL
          AND fl.family_id = @familyId
        FOR UPDATE
        ''',
        parameters: QueryParameters.named({'itemId': itemId, 'familyId': familyId}),
        transaction: transaction,
      );
      if (locked.isEmpty) {
        throw Exception('List item not found');
      }

      final current = locked.first.toColumnMap();
      if (!isFresh) {
        return _mapItem(current);
      }

      final now = DateTime.now().toUtc();
      final nextBought = !(current['is_bought'] as bool);

      await session.db.unsafeExecute(
        '''
        UPDATE list_item
        SET
          is_bought = @isBought,
          bought_by_profile_id = CASE WHEN @isBought THEN @profileId ELSE NULL END,
          bought_at = CASE WHEN @isBought THEN @boughtAt ELSE NULL END,
          updated_at = @updatedAt,
          version = version + 1
        WHERE id = @itemId
        ''',
        parameters: QueryParameters.named({
          'itemId': itemId,
          'isBought': nextBought,
          'profileId': actorProfileId,
          'boughtAt': now,
          'updatedAt': now,
        }),
        transaction: transaction,
      );

      await _appendItemHistory(
        session,
        itemId: itemId,
        actorProfileId: actorProfileId,
        eventType: nextBought ? 'bought' : 'unbought',
        transaction: transaction,
      );

      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list_item',
        entityId: itemId,
        transaction: transaction,
      );

      final updated = await session.db.unsafeQuery(
        '''
        SELECT
          id,
          list_id,
          title,
          qty,
          unit,
          note,
          price_cents,
          category,
          position_index,
          is_bought,
          bought_by_profile_id,
          bought_at,
          updated_at,
          version
        FROM list_item
        WHERE id = @itemId
        LIMIT 1
        ''',
        parameters: QueryParameters.named({'itemId': itemId}),
        transaction: transaction,
      );

      return _mapItem(updated.first.toColumnMap());
    });
  }

  Future<OperationResult> reorderItems(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int listId,
    required List<int> orderedItemIds,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.reorderItems',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        return OperationResult(success: true, message: 'Already processed');
      }

      for (int i = 0; i < orderedItemIds.length; i++) {
        await session.db.unsafeExecute(
          '''
          UPDATE list_item
          SET position_index = @position,
              updated_at = @updatedAt,
              version = version + 1
          WHERE id = @itemId
            AND list_id = @listId
            AND deleted_at IS NULL
          ''',
          parameters: QueryParameters.named({
            'position': i + 1,
            'updatedAt': DateTime.now().toUtc(),
            'itemId': orderedItemIds[i],
            'listId': listId,
          }),
          transaction: transaction,
        );
      }

      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list',
        entityId: listId,
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Reordered');
    });
  }

  Future<List<ListItemDto>> listItems(
    Session session, {
    required int familyId,
    required int listId,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');

    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        li.id,
        li.list_id,
        li.title,
        li.qty,
        li.unit,
        li.note,
        li.price_cents,
        li.category,
        li.position_index,
        li.is_bought,
        li.bought_by_profile_id,
        li.bought_at,
        li.updated_at,
        li.version
      FROM list_item li
      JOIN family_list fl ON fl.id = li.list_id
      WHERE li.list_id = @listId
        AND fl.family_id = @familyId
        AND li.deleted_at IS NULL
      ORDER BY li.position_index ASC, li.id ASC
      ''',
      parameters: QueryParameters.named({'listId': listId, 'familyId': familyId}),
    );

    return rows.map((row) => _mapItem(row.toColumnMap())).toList();
  }

  Future<FamilyListDto> _findList(
    Session session,
    int listId, {
    Transaction? transaction,
  }) async {
    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        title,
        list_type,
        created_by_profile_id,
        updated_at,
        version
      FROM family_list
      WHERE id = @id
      LIMIT 1
      ''',
      parameters: QueryParameters.named({'id': listId}),
      transaction: transaction,
    );

    return _mapList(rows.first.toColumnMap());
  }

  Future<void> _appendItemHistory(
    Session session, {
    required int itemId,
    required int actorProfileId,
    required String eventType,
    Transaction? transaction,
  }) async {
    await session.db.unsafeExecute(
      '''
      INSERT INTO list_item_history (
        item_id,
        actor_profile_id,
        event_type,
        created_at
      ) VALUES (
        @itemId,
        @actor,
        @eventType,
        @createdAt
      )
      ''',
      parameters: QueryParameters.named({
        'itemId': itemId,
        'actor': actorProfileId,
        'eventType': eventType,
        'createdAt': DateTime.now().toUtc(),
      }),
      transaction: transaction,
    );
  }

  Future<void> _emitListChange(
    Session session, {
    required int familyId,
    required String entityType,
    required int entityId,
    Transaction? transaction,
  }) async {
    await changeFeed.appendChange(
      session,
      feature: 'lists',
      entityType: entityType,
      entityId: entityId,
      operation: 'upserted',
      familyId: familyId,
      version: 1,
      transaction: transaction,
    );

    await realtime.publish(
      session,
      familyId: familyId,
      event: FamilyRealtimeEvent(
        familyId: familyId,
        feature: 'lists',
        entityType: entityType,
        entityId: entityId,
        eventType: 'lists.updated',
        changedAt: DateTime.now().toUtc(),
      ),
    );
  }

  FamilyListDto _mapList(Map<String, dynamic> row) {
    return FamilyListDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int,
      title: row['title'] as String,
      listType: row['list_type'] as String,
      createdByProfileId: row['created_by_profile_id'] as int,
      updatedAt: row['updated_at'] as DateTime,
      version: row['version'] as int,
    );
  }

  ListItemDto _mapItem(Map<String, dynamic> row) {
    return ListItemDto(
      id: row['id'] as int,
      listId: row['list_id'] as int,
      title: row['title'] as String,
      qty: (row['qty'] as num).toDouble(),
      unit: row['unit'] as String?,
      note: row['note'] as String?,
      priceCents: row['price_cents'] as int?,
      category: row['category'] as String?,
      positionIndex: row['position_index'] as int,
      isBought: row['is_bought'] as bool,
      boughtByProfileId: row['bought_by_profile_id'] as int?,
      boughtAt: row['bought_at'] as DateTime?,
      updatedAt: row['updated_at'] as DateTime,
      version: row['version'] as int,
    );
  }
}
