BEGIN;

CREATE TABLE IF NOT EXISTS task (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  title text NOT NULL,
  description text,
  is_personal boolean NOT NULL DEFAULT false,
  priority text NOT NULL DEFAULT 'normal',
  status text NOT NULL DEFAULT 'open',
  due_at timestamp without time zone,
  recurrence_mode text,
  recurrence_rrule text,
  assignee_profile_id bigint,
  created_by_profile_id bigint NOT NULL,
  completed_at timestamp without time zone,
  source_task_id bigint,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT task_family_fk FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT task_assignee_fk FOREIGN KEY (assignee_profile_id) REFERENCES app_profile(id),
  CONSTRAINT task_creator_fk FOREIGN KEY (created_by_profile_id) REFERENCES app_profile(id),
  CONSTRAINT task_source_fk FOREIGN KEY (source_task_id) REFERENCES task(id),
  CONSTRAINT task_unique_generated_next UNIQUE (source_task_id, due_at)
);
CREATE INDEX IF NOT EXISTS task_family_status_idx
  ON task (family_id, status, due_at);

CREATE TABLE IF NOT EXISTS task_history (
  id bigserial PRIMARY KEY,
  task_id bigint NOT NULL,
  actor_profile_id bigint NOT NULL,
  event_type text NOT NULL,
  details text NOT NULL,
  created_at timestamp without time zone NOT NULL,
  CONSTRAINT task_history_task_fk FOREIGN KEY (task_id) REFERENCES task(id),
  CONSTRAINT task_history_actor_fk FOREIGN KEY (actor_profile_id) REFERENCES app_profile(id)
);

COMMIT;
