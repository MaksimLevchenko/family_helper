BEGIN;

CREATE TABLE IF NOT EXISTS app_profile (
  id bigserial PRIMARY KEY,
  auth_user_id uuid NOT NULL UNIQUE,
  display_name text NOT NULL,
  timezone text NOT NULL DEFAULT 'UTC',
  avatar_media_id bigint,
  analytics_opt_in boolean NOT NULL DEFAULT false,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS security_event (
  id bigserial PRIMARY KEY,
  auth_user_id text NOT NULL,
  event_type text NOT NULL,
  success boolean NOT NULL,
  payload_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamp without time zone NOT NULL
);
CREATE INDEX IF NOT EXISTS security_event_auth_created_idx
  ON security_event (auth_user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS audit_log (
  id bigserial PRIMARY KEY,
  family_id bigint,
  actor_profile_id bigint NOT NULL,
  action text NOT NULL,
  payload_json jsonb NOT NULL,
  created_at timestamp without time zone NOT NULL
);
CREATE INDEX IF NOT EXISTS audit_log_family_created_idx
  ON audit_log (family_id, created_at DESC);

CREATE TABLE IF NOT EXISTS idempotency_key (
  id bigserial PRIMARY KEY,
  actor_auth_user_id uuid NOT NULL,
  action text NOT NULL,
  client_operation_id uuid NOT NULL,
  created_at timestamp without time zone NOT NULL,
  UNIQUE (actor_auth_user_id, action, client_operation_id)
);

CREATE TABLE IF NOT EXISTS change_feed (
  id bigserial PRIMARY KEY,
  family_id bigint,
  feature text NOT NULL,
  entity_type text NOT NULL,
  entity_id bigint NOT NULL,
  operation text NOT NULL,
  changed_at timestamp without time zone NOT NULL,
  tombstone boolean NOT NULL DEFAULT false,
  version integer NOT NULL,
  payload_json jsonb NOT NULL DEFAULT '{}'::jsonb
);
CREATE INDEX IF NOT EXISTS change_feed_family_changed_idx
  ON change_feed (family_id, changed_at, id);
CREATE INDEX IF NOT EXISTS change_feed_changed_idx
  ON change_feed (changed_at, id);

COMMIT;
