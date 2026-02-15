BEGIN;

CREATE TABLE IF NOT EXISTS money_goal (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  title text NOT NULL,
  description text,
  target_amount_cents bigint NOT NULL,
  current_amount_cents bigint NOT NULL DEFAULT 0,
  currency char(3) NOT NULL DEFAULT 'RUB',
  deadline_at timestamp without time zone,
  reached_at timestamp without time zone,
  created_by_profile_id bigint NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT money_goal_family_fk FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT money_goal_creator_fk FOREIGN KEY (created_by_profile_id) REFERENCES app_profile(id)
);

CREATE TABLE IF NOT EXISTS money_contribution (
  id bigserial PRIMARY KEY,
  goal_id bigint NOT NULL,
  profile_id bigint NOT NULL,
  amount_cents bigint NOT NULL,
  currency char(3) NOT NULL,
  note text,
  client_operation_id uuid NOT NULL,
  created_at timestamp without time zone NOT NULL,
  revoked_at timestamp without time zone,
  CONSTRAINT money_contribution_goal_fk FOREIGN KEY (goal_id) REFERENCES money_goal(id),
  CONSTRAINT money_contribution_profile_fk FOREIGN KEY (profile_id) REFERENCES app_profile(id),
  UNIQUE (goal_id, client_operation_id)
);
CREATE INDEX IF NOT EXISTS money_contribution_goal_created_idx
  ON money_contribution (goal_id, created_at DESC);

COMMIT;
