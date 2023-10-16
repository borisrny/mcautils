#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

TABLE_NAME=current_assignment
pg_execute "CREATE TABLE IF NOT EXISTS %SCHEMA%.${TABLE_NAME} (
    event_id INTEGER
);"

pg_execute "CREATE UNIQUE INDEX IF NOT EXISTS ${TABLE_NAME}_event_id_key ON %SCHEMA%.${TABLE_NAME} (event_id)"

pg_execute "INSERT INTO %SCHEMA%.${TABLE_NAME}
  SELECT T.id FROM (
    select DISTINCT ON(batch_id) id, action from %SCHEMA%.businessevent
    WHERE subject_action->>'action'='Assign Deal'
    AND subject_type=1
    ORDER BY batch_id, id DESC
  ) AS T WHERE T.action in (1, 4)
ON CONFLICT (event_id) DO NOTHING;
"
