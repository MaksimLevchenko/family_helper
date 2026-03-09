BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "idempotency_key" ADD COLUMN "resourceType" text;
ALTER TABLE "idempotency_key" ADD COLUMN "resourceId" bigint;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "app_profile"
        GROUP BY "authUserId"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on app_profile(authUserId): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "account_deletion_request"
        GROUP BY "profileId"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on account_deletion_request(profileId): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "idempotency_key"
        GROUP BY "actorAuthUserId", "action", "clientOperationId"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on idempotency_key(actorAuthUserId, action, clientOperationId): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "money_contribution"
        WHERE "clientOperationId" IS NOT NULL
        GROUP BY "goalId", "clientOperationId"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on money_contribution(goalId, clientOperationId): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "notification_preference"
        GROUP BY "profileId", "notificationType"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on notification_preference(profileId, notificationType): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "push_token"
        GROUP BY "profileId", "token"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on push_token(profileId, token): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "family_member"
        WHERE "deletedAt" IS NULL
        GROUP BY "familyId", "profileId"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on active family_member(familyId, profileId): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "task"
        WHERE "sourceTaskId" IS NOT NULL
          AND "deletedAt" IS NULL
        GROUP BY "sourceTaskId", "dueAt"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on active task(sourceTaskId, dueAt): duplicate rows exist.';
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "calendar_event_override"
        WHERE "deletedAt" IS NULL
        GROUP BY "eventId", "occurrenceStart"
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Cannot create unique index on active calendar_event_override(eventId, occurrenceStart): duplicate rows exist.';
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS "app_profile_auth_user_id_idx"
    ON "app_profile" USING btree ("authUserId");
CREATE UNIQUE INDEX IF NOT EXISTS "account_deletion_request_profile_id_idx"
    ON "account_deletion_request" USING btree ("profileId");
CREATE UNIQUE INDEX IF NOT EXISTS "idempotency_key_actor_action_client_operation_idx"
    ON "idempotency_key" USING btree ("actorAuthUserId", "action", "clientOperationId");
CREATE UNIQUE INDEX IF NOT EXISTS "money_contribution_goal_client_operation_idx"
    ON "money_contribution" USING btree ("goalId", "clientOperationId");
CREATE UNIQUE INDEX IF NOT EXISTS "notification_preference_profile_type_idx"
    ON "notification_preference" USING btree ("profileId", "notificationType");
CREATE UNIQUE INDEX IF NOT EXISTS "push_token_profile_token_idx"
    ON "push_token" USING btree ("profileId", "token");
CREATE UNIQUE INDEX IF NOT EXISTS "family_member_active_family_profile_idx"
    ON "family_member" USING btree ("familyId", "profileId")
    WHERE "deletedAt" IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS "task_active_source_due_idx"
    ON "task" USING btree ("sourceTaskId", "dueAt")
    WHERE "sourceTaskId" IS NOT NULL AND "deletedAt" IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS "calendar_event_override_active_occurrence_idx"
    ON "calendar_event_override" USING btree ("eventId", "occurrenceStart")
    WHERE "deletedAt" IS NULL;

--
-- MIGRATION VERSION FOR family_helper
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('family_helper', '20260309190241359', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260309190241359', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
