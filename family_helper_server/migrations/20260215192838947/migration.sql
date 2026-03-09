BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_deletion_request" (
    "id" bigserial PRIMARY KEY,
    "profileId" bigint NOT NULL,
    "status" text NOT NULL,
    "scheduledHardDeleteAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "cancelledAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_profile" (
    "id" bigserial PRIMARY KEY,
    "authUserId" text NOT NULL,
    "displayName" text NOT NULL,
    "timezone" text NOT NULL,
    "avatarMediaId" bigint,
    "analyticsOptIn" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_log" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint,
    "actorProfileId" bigint NOT NULL,
    "action" text NOT NULL,
    "payloadJson" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "calendar_event" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "timezone" text NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone NOT NULL,
    "rrule" text,
    "colorKey" text,
    "category" text,
    "createdByProfileId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "calendar_event_override" (
    "id" bigserial PRIMARY KEY,
    "eventId" bigint NOT NULL,
    "occurrenceStart" timestamp without time zone NOT NULL,
    "overrideTitle" text,
    "overrideStartsAt" timestamp without time zone,
    "overrideEndsAt" timestamp without time zone,
    "cancelled" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "change_feed" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint,
    "feature" text NOT NULL,
    "entityType" text NOT NULL,
    "entityId" bigint NOT NULL,
    "operation" text NOT NULL,
    "changedAt" timestamp without time zone NOT NULL,
    "tombstone" boolean NOT NULL,
    "version" bigint NOT NULL,
    "payloadJson" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "family" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "ownerProfileId" bigint NOT NULL,
    "memberLimit" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "family_invite" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "inviteType" text NOT NULL,
    "email" text,
    "inviteCode" text NOT NULL,
    "token" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "acceptedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "family_list" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "title" text NOT NULL,
    "listType" text NOT NULL,
    "createdByProfileId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "family_member" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "profileId" bigint NOT NULL,
    "role" text NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "idempotency_key" (
    "id" bigserial PRIMARY KEY,
    "actorAuthUserId" text NOT NULL,
    "action" text NOT NULL,
    "clientOperationId" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "list_item" (
    "id" bigserial PRIMARY KEY,
    "listId" bigint NOT NULL,
    "title" text NOT NULL,
    "qty" double precision NOT NULL,
    "unit" text,
    "note" text,
    "priceCents" bigint,
    "category" text,
    "positionIndex" bigint NOT NULL,
    "isBought" boolean NOT NULL,
    "boughtByProfileId" bigint,
    "boughtAt" timestamp without time zone,
    "createdByProfileId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "list_item_history" (
    "id" bigserial PRIMARY KEY,
    "itemId" bigint NOT NULL,
    "actorProfileId" bigint NOT NULL,
    "eventType" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "media_attachment" (
    "id" bigserial PRIMARY KEY,
    "mediaId" bigint NOT NULL,
    "entityType" text NOT NULL,
    "entityId" bigint NOT NULL,
    "createdByProfileId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "media_object" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint,
    "uploadedByProfileId" bigint NOT NULL,
    "objectKey" text NOT NULL,
    "bucket" text NOT NULL,
    "mimeType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "status" text NOT NULL,
    "thumbnailKey" text,
    "clientOperationId" text,
    "uploadExpiresAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "money_contribution" (
    "id" bigserial PRIMARY KEY,
    "goalId" bigint NOT NULL,
    "profileId" bigint NOT NULL,
    "amountCents" bigint NOT NULL,
    "currency" text NOT NULL,
    "note" text,
    "clientOperationId" text,
    "createdAt" timestamp without time zone NOT NULL,
    "revokedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "money_goal" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "targetAmountCents" bigint NOT NULL,
    "currentAmountCents" bigint NOT NULL,
    "currency" text NOT NULL,
    "deadlineAt" timestamp without time zone,
    "reachedAt" timestamp without time zone,
    "createdByProfileId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_preference" (
    "id" bigserial PRIMARY KEY,
    "profileId" bigint NOT NULL,
    "notificationType" text NOT NULL,
    "enabled" boolean NOT NULL,
    "quietHoursStart" text,
    "quietHoursEnd" text,
    "updatedAt" timestamp without time zone NOT NULL,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "privacy_export_job" (
    "id" bigserial PRIMARY KEY,
    "profileId" bigint NOT NULL,
    "status" text NOT NULL,
    "objectKey" text NOT NULL,
    "signedUrl" text,
    "expiresAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "push_token" (
    "id" bigserial PRIMARY KEY,
    "profileId" bigint NOT NULL,
    "token" text NOT NULL,
    "platform" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reminder" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "entityType" text NOT NULL,
    "entityId" bigint NOT NULL,
    "profileId" bigint NOT NULL,
    "remindAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "payloadJson" text NOT NULL,
    "clientOperationId" text,
    "firedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "security_event" (
    "id" bigserial PRIMARY KEY,
    "authUserId" text NOT NULL,
    "eventType" text NOT NULL,
    "success" boolean NOT NULL,
    "payloadJson" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "isPersonal" boolean NOT NULL,
    "priority" text NOT NULL,
    "status" text NOT NULL,
    "dueAt" timestamp without time zone,
    "recurrenceMode" text,
    "recurrenceRrule" text,
    "assigneeProfileId" bigint,
    "createdByProfileId" bigint NOT NULL,
    "completedAt" timestamp without time zone,
    "sourceTaskId" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "version" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task_history" (
    "id" bigserial PRIMARY KEY,
    "taskId" bigint NOT NULL,
    "actorProfileId" bigint NOT NULL,
    "eventType" text NOT NULL,
    "details" text,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR family_helper
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('family_helper', '20260215192838947', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260215192838947', "timestamp" = now();

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
