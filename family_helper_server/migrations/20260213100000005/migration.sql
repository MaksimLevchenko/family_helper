BEGIN;

CREATE TABLE IF NOT EXISTS family_list (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  title text NOT NULL,
  list_type text NOT NULL,
  created_by_profile_id bigint NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT family_list_family_fk FOREIGN KEY (family_id) REFERENCES family(id),
  CONSTRAINT family_list_creator_fk FOREIGN KEY (created_by_profile_id) REFERENCES app_profile(id)
);

CREATE TABLE IF NOT EXISTS list_item (
  id bigserial PRIMARY KEY,
  list_id bigint NOT NULL,
  title text NOT NULL,
  qty double precision NOT NULL DEFAULT 1,
  unit text,
  note text,
  price_cents bigint,
  category text,
  position_index integer NOT NULL,
  is_bought boolean NOT NULL DEFAULT false,
  bought_by_profile_id bigint,
  bought_at timestamp without time zone,
  created_by_profile_id bigint NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT list_item_list_fk FOREIGN KEY (list_id) REFERENCES family_list(id),
  CONSTRAINT list_item_bought_by_fk FOREIGN KEY (bought_by_profile_id) REFERENCES app_profile(id),
  CONSTRAINT list_item_creator_fk FOREIGN KEY (created_by_profile_id) REFERENCES app_profile(id)
);
CREATE INDEX IF NOT EXISTS list_item_list_position_idx
  ON list_item (list_id, position_index, id);

CREATE TABLE IF NOT EXISTS list_item_history (
  id bigserial PRIMARY KEY,
  item_id bigint NOT NULL,
  actor_profile_id bigint NOT NULL,
  event_type text NOT NULL,
  created_at timestamp without time zone NOT NULL,
  CONSTRAINT list_item_history_item_fk FOREIGN KEY (item_id) REFERENCES list_item(id),
  CONSTRAINT list_item_history_actor_fk FOREIGN KEY (actor_profile_id) REFERENCES app_profile(id)
);

CREATE TABLE IF NOT EXISTS list_category (
  id bigserial PRIMARY KEY,
  family_id bigint NOT NULL,
  name text NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  deleted_at timestamp without time zone,
  version integer NOT NULL DEFAULT 1,
  CONSTRAINT list_category_family_fk FOREIGN KEY (family_id) REFERENCES family(id),
  UNIQUE (family_id, name)
);

COMMIT;
