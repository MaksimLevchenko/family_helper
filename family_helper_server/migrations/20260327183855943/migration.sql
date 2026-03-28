BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_notification" (
    "id" bigserial PRIMARY KEY,
    "profileId" bigint NOT NULL,
    "familyId" bigint NOT NULL,
    "category" text NOT NULL,
    "title" text NOT NULL,
    "body" text NOT NULL,
    "entityType" text NOT NULL,
    "entityId" bigint NOT NULL,
    "route" text,
    "payloadJson" text NOT NULL,
    "isRead" boolean NOT NULL,
    "readAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "pushedAt" timestamp without time zone,
    "pushStatus" text NOT NULL,
    "version" bigint NOT NULL
);

-- Indexes
CREATE INDEX "app_notification_profile_family_created_idx" ON "app_notification" USING btree ("profileId", "familyId", "createdAt");
CREATE INDEX "app_notification_profile_family_read_idx" ON "app_notification" USING btree ("profileId", "familyId", "isRead");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "push_token" ADD COLUMN "provider" text;
ALTER TABLE "push_token" ADD COLUMN "deviceId" text;
ALTER TABLE "push_token" ADD COLUMN "appVersion" text;
ALTER TABLE "push_token" ADD COLUMN "lastSeenAt" timestamp without time zone;
ALTER TABLE "push_token" ADD COLUMN "lastErrorAt" timestamp without time zone;
ALTER TABLE "push_token" ADD COLUMN "disabledAt" timestamp without time zone;

--
-- MIGRATION VERSION FOR family_helper
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('family_helper', '20260327183855943', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260327183855943', "timestamp" = now();

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
