#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

TABLE_NAME=user_message
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${TABLE_NAME}"
pg_execute "CREATE TABLE  %SCHEMA%.${TABLE_NAME} (
  id SERIAL PRIMARY KEY,
  target_type INTEGER,
  author INTEGER,
  target INTEGER[],
  message TEXT,
  update_ts timestamp with time zone DEFAULT now()
);"
pg_execute "alter table %SCHEMA%.${TABLE_NAME} OWNER to %OWNER%;"
pg_execute "
DROP INDEX IF EXISTS %SCHEMA%.${TABLE_NAME}_target_idx;
CREATE INDEX ${TABLE_NAME}_target_idx
    ON %SCHEMA%.${TABLE_NAME} USING btree
    (target_type, target)
    TABLESPACE pg_default;
"

TABLE_NAME=user_last_message
pg_execute "DROP TABLE IF EXISTS  %SCHEMA%.${TABLE_NAME}"
pg_execute "CREATE TABLE  %SCHEMA%.${TABLE_NAME} (
  user_id integer PRIMARY KEY,
  last_message_id integer
);"
