#!/bin/bash

set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/pg_util.bash"
TABLE="%SCHEMA%.changelog"

pg_execute "DROP TABLE IF EXISTS ${TABLE}"

pg_execute "

CREATE TABLE ${TABLE} (
    id serial,
    actiondate timestamp DEFAULT now(),
    userid integer,
    table_name text,
    recid bigint,
    operation text,
    old_val json,
    new_val json
);

CREATE INDEX changelog_tname_recid_idx ON ${TABLE} (table_name, recid);

"

pg_execute "CREATE INDEX login_username_idx ON %SCHEMA%.login(userid);"
