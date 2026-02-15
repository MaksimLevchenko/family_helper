BEGIN;

CREATE TABLE IF NOT EXISTS push_token (
  id bigserial PRIMARY KEY,
  profile_id bigint NOT NULL,
  token text NOT NULL,
  platform text NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT push_token_profile_fk FOREIGN KEY (profile_id) REFERENCES app_profile(id),
  UNIQUE (profile_id, token)
);

CREATE TABLE IF NOT EXISTS notification_preference (
  id bigserial PRIMARY KEY,
  profile_id bigint NOT NULL,
  notification_type text NOT NULL,
  enabled boolean NOT NULL,
  quiet_hours_start text,
  quiet_hours_end text,
  updated_at timestamp without time zone NOT NULL,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT notification_preference_profile_fk FOREIGN KEY (profile_id) REFERENCES app_profile(id),
  UNIQUE (profile_id, notification_type)
);

CREATE TABLE IF NOT EXISTS reminder (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  entity_type text NOT NULL,
  entity_id bigint NOT NULL,
  profile_id bigint NOT NULL,
  remind_at timestamp without time zone NOT NULL,
  status text NOT NULL,
  payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  client_operation_id uuid NOT NULL,
  fired_at timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  CONSTRAINT reminder_family_fk FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT reminder_profile_fk FOREIGN KEY (profile_id) REFERENCES app_profile(id),
  UNIQUE (profile_id, client_operation_id)
);
CREATE INDEX IF NOT EXISTS reminder_status_due_idx
  ON reminder (status, remind_at);

COMMIT;
