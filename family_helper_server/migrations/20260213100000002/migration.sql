BEGIN;

CREATE TABLE IF NOT EXISTS family (
  id bigserial PRIMARY KEY,
  title text NOT NULL,
  owner_profile_id bigint NOT NULL,
  member_limit integer NOT NULL DEFAULT 2,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT family_owner_profile_fk
    FOREIGN KEY (owner_profile_id) REFERENCES app_profile(id)
);

CREATE TABLE IF NOT EXISTS family_member (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  profile_id bigint NOT NULL,
  role text NOT NULL,
  status text NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT family_member_family_fk
    FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT family_member_profile_fk
    FOREIGN KEY (profile_id) REFERENCES app_profile(id),
  UNIQUE (family_id, profile_id)
);
CREATE INDEX IF NOT EXISTS family_member_family_role_idx
  ON family_member (family_id, role, status);

CREATE TABLE IF NOT EXISTS family_invite (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  invite_type text NOT NULL,
  email text,
  invite_code text NOT NULL,
  token text NOT NULL,
  expires_at timestamp without time zone NOT NULL,
  accepted_at timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT family_invite_family_fk
    FOREIGN KEY (family_id) REFERENCES family(id)
);
CREATE UNIQUE INDEX IF NOT EXISTS family_invite_code_unique
  ON family_invite (invite_code);
CREATE UNIQUE INDEX IF NOT EXISTS family_invite_token_unique
  ON family_invite (token);

COMMIT;
