BEGIN;

--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION ALTER TABLE
--
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "account_deletion_request"
    ADD CONSTRAINT "account_deletion_request_fk_0"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_notification"
    ADD CONSTRAINT "app_notification_fk_0"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "app_notification"
    ADD CONSTRAINT "app_notification_fk_1"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_profile"
    ADD CONSTRAINT "app_profile_fk_0"
    FOREIGN KEY("avatarMediaId")
    REFERENCES "media_object"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "audit_log"
    ADD CONSTRAINT "audit_log_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "audit_log"
    ADD CONSTRAINT "audit_log_fk_1"
    FOREIGN KEY("actorProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "calendar_event"
    ADD CONSTRAINT "calendar_event_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "calendar_event"
    ADD CONSTRAINT "calendar_event_fk_1"
    FOREIGN KEY("createdByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "calendar_event_override"
    ADD CONSTRAINT "calendar_event_override_fk_0"
    FOREIGN KEY("eventId")
    REFERENCES "calendar_event"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "change_feed"
    ADD CONSTRAINT "change_feed_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "family"
    ADD CONSTRAINT "family_fk_0"
    FOREIGN KEY("ownerProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "family_invite"
    ADD CONSTRAINT "family_invite_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "family_list"
    ADD CONSTRAINT "family_list_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "family_list"
    ADD CONSTRAINT "family_list_fk_1"
    FOREIGN KEY("createdByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "family_member"
    ADD CONSTRAINT "family_member_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "family_member"
    ADD CONSTRAINT "family_member_fk_1"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "list_item"
    ADD CONSTRAINT "list_item_fk_0"
    FOREIGN KEY("listId")
    REFERENCES "family_list"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "list_item"
    ADD CONSTRAINT "list_item_fk_1"
    FOREIGN KEY("boughtByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "list_item"
    ADD CONSTRAINT "list_item_fk_2"
    FOREIGN KEY("createdByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "list_item_history"
    ADD CONSTRAINT "list_item_history_fk_0"
    FOREIGN KEY("itemId")
    REFERENCES "list_item"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "list_item_history"
    ADD CONSTRAINT "list_item_history_fk_1"
    FOREIGN KEY("actorProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "media_attachment"
    ADD CONSTRAINT "media_attachment_fk_0"
    FOREIGN KEY("mediaId")
    REFERENCES "media_object"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "media_attachment"
    ADD CONSTRAINT "media_attachment_fk_1"
    FOREIGN KEY("createdByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "media_object"
    ADD CONSTRAINT "media_object_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "media_object"
    ADD CONSTRAINT "media_object_fk_1"
    FOREIGN KEY("uploadedByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "money_contribution"
    ADD CONSTRAINT "money_contribution_fk_0"
    FOREIGN KEY("goalId")
    REFERENCES "money_goal"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "money_contribution"
    ADD CONSTRAINT "money_contribution_fk_1"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "money_goal"
    ADD CONSTRAINT "money_goal_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "money_goal"
    ADD CONSTRAINT "money_goal_fk_1"
    FOREIGN KEY("createdByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notification_preference"
    ADD CONSTRAINT "notification_preference_fk_0"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "privacy_export_job"
    ADD CONSTRAINT "privacy_export_job_fk_0"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "push_token"
    ADD CONSTRAINT "push_token_fk_0"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "reminder"
    ADD CONSTRAINT "reminder_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "reminder"
    ADD CONSTRAINT "reminder_fk_1"
    FOREIGN KEY("profileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_1"
    FOREIGN KEY("assigneeProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_2"
    FOREIGN KEY("createdByProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_3"
    FOREIGN KEY("sourceTaskId")
    REFERENCES "task"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "task_history"
    ADD CONSTRAINT "task_history_fk_0"
    FOREIGN KEY("taskId")
    REFERENCES "task"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "task_history"
    ADD CONSTRAINT "task_history_fk_1"
    FOREIGN KEY("actorProfileId")
    REFERENCES "app_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR family_helper
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('family_helper', '20260405214107091', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260405214107091', "timestamp" = now();

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
