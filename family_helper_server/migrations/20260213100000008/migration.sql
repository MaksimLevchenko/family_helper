BEGIN;

CREATE TABLE IF NOT EXISTS media_object (
  id bigserial PRIMARY KEY,
  family_id bigint,
  uploaded_by_profile_id bigint NOT NULL,
  object_key text NOT NULL,
  bucket text NOT NULL,
  mime_type text NOT NULL,
  size_bytes bigint NOT NULL,
  status text NOT NULL,
  thumbnail_key text,
  client_operation_id uuid NOT NULL,
  upload_expires_at timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT media_object_family_fk FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT media_object_profile_fk FOREIGN KEY (uploaded_by_profile_id) REFERENCES app_profile(id),
  UNIQUE (object_key)
);
CREATE UNIQUE INDEX IF NOT EXISTS media_operation_unique_idx
  ON media_object (uploaded_by_profile_id, client_operation_id);

CREATE TABLE IF NOT EXISTS media_attachment (
  id bigserial PRIMARY KEY,
  family_id bigint,
  entity_type text NOT NULL,
  entity_id bigint NOT NULL,
  media_id bigint NOT NULL,
  created_by_profile_id bigint NOT NULL,
  created_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT media_attachment_family_fk FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT media_attachment_media_fk FOREIGN KEY (media_id) REFERENCES media_object(id),
  CONSTRAINT media_attachment_profile_fk FOREIGN KEY (created_by_profile_id) REFERENCES app_profile(id)
);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'app_profile_avatar_media_fk'
  ) THEN
    ALTER TABLE app_profile
      ADD CONSTRAINT app_profile_avatar_media_fk
      FOREIGN KEY (avatar_media_id) REFERENCES media_object(id);
  END IF;
END $$;

COMMIT;
