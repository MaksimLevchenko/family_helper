BEGIN;

CREATE TABLE IF NOT EXISTS calendar_event (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  title text NOT NULL,
  description text,
  timezone text NOT NULL,
  starts_at timestamp without time zone NOT NULL,
  ends_at timestamp without time zone NOT NULL,
  rrule text,
  color_key text,
  category text,
  created_by_profile_id bigint NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT calendar_event_family_fk
    FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT calendar_event_creator_fk
    FOREIGN KEY (created_by_profile_id) REFERENCES app_profile(id)
);
CREATE INDEX IF NOT EXISTS calendar_event_family_time_idx
  ON calendar_event (family_id, starts_at, ends_at);

CREATE TABLE IF NOT EXISTS calendar_event_override (
  id bigserial PRIMARY KEY,
  event_id bigint NOT NULL,
  occurrence_start timestamp without time zone NOT NULL,
  override_title text,
  override_starts_at timestamp without time zone,
  override_ends_at timestamp without time zone,
  cancelled boolean NOT NULL DEFAULT false,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT calendar_override_event_fk
    FOREIGN KEY (event_id) REFERENCES calendar_event(id),
  UNIQUE (event_id, occurrence_start)
);

COMMIT;
