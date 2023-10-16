#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/pg_util.bash"

TABLE="%SCHEMA%.usergrid"

pg_execute "DROP TABLE IF EXISTS ${TABLE};"

pg_execute "
CREATE TABLE ${TABLE}
(
  id SERIAL PRIMARY KEY,
  userid integer NOT NULL,
  name VARCHAR(255),
  label VARCHAR(255),
  value TEXT,
  preferred boolean default false NOT NULL
)
with ( OIDS = FALSE ) TABLESPACE pg_default;"

pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"

pg_execute "CREATE UNIQUE INDEX usergrid_unique ON ${TABLE} (userid, name, label)"
