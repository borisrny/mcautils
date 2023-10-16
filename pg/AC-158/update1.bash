#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="%SCHEMA%.bewatchdog"
pg_execute "
ALTER TABLE ${TABLE} ADD COLUMN action_ts timestamp;
"
pg_execute "
CREATE INDEX bewatchdog_event_id_tag_idx ON ${TABLE} (event_id, tag);
"

