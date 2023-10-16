#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="%SCHEMA%.bewatchdog"
pg_execute "DROP TABLE IF EXISTS ${TABLE};"
pg_execute "
CREATE TABLE ${TABLE}
(
  tag character varying,
  event_id integer NOT NULL,
  value TEXT
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
"


