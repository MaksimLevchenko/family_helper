BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "calendar_event" ADD COLUMN "reminderOffsetMinutes" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "calendar_event_override" ADD COLUMN "overrideReminderOffsetMinutes" bigint;
ALTER TABLE "calendar_event_override" ADD COLUMN "overrideReminderCleared" boolean;

--
-- MIGRATION VERSION FOR family_helper
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('family_helper', '20260326103054613', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260326103054613', "timestamp" = now();

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
