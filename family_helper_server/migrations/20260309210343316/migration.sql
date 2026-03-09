BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX IF NOT EXISTS "account_deletion_request_profile_id_idx" ON "account_deletion_request" USING btree ("profileId");
--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX IF NOT EXISTS "app_profile_auth_user_id_idx" ON "app_profile" USING btree ("authUserId");
--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX IF NOT EXISTS "idempotency_key_actor_action_client_operation_idx" ON "idempotency_key" USING btree ("actorAuthUserId", "action", "clientOperationId");
--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX IF NOT EXISTS "money_contribution_goal_client_operation_idx" ON "money_contribution" USING btree ("goalId", "clientOperationId");
--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX IF NOT EXISTS "notification_preference_profile_type_idx" ON "notification_preference" USING btree ("profileId", "notificationType");
--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX IF NOT EXISTS "push_token_profile_token_idx" ON "push_token" USING btree ("profileId", "token");

--
-- MIGRATION VERSION FOR family_helper
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('family_helper', '20260309210343316', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260309210343316', "timestamp" = now();

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
