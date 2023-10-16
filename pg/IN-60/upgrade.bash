#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="userdefaults"

pg_execute "ALTER TABLE %SCHEMA%.${TABLE} ADD COLUMN qb_name character varying;"
pg_execute "COMMENT ON COLUMN %SCHEMA%.${TABLE}.qb_name IS 'Quick Books Name';"
