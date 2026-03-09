BEGIN;

DROP INDEX IF EXISTS "family_member_active_family_profile_idx";
DROP INDEX IF EXISTS "task_active_source_due_idx";
DROP INDEX IF EXISTS "calendar_event_override_active_occurrence_idx";

--
-- MIGRATION VERSION FOR _repair
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '20260309205500000', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260309205500000', "timestamp" = now();

COMMIT;
