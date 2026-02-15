BEGIN;

CREATE TABLE IF NOT EXISTS privacy_export_job (
  id bigserial PRIMARY KEY,
  profile_id bigint NOT NULL,
  status text NOT NULL,
  object_key text NOT NULL,
  signed_url text,
  expires_at timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  completed_at timestamp without time zone,
  CONSTRAINT privacy_export_profile_fk FOREIGN KEY (profile_id) REFERENCES app_profile(id)
);

CREATE TABLE IF NOT EXISTS account_deletion_request (
  id bigserial PRIMARY KEY,
  profile_id bigint NOT NULL UNIQUE,
  status text NOT NULL,
  scheduled_hard_delete_at timestamp without time zone NOT NULL,
  created_at timestamp without time zone NOT NULL,
  cancelled_at timestamp without time zone,
  CONSTRAINT account_delete_profile_fk FOREIGN KEY (profile_id) REFERENCES app_profile(id)
);

COMMIT;
