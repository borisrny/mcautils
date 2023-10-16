#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="mcaattributestag"
pg_execute "DROP TABLE IF EXISTS ${TABLE};"
pg_execute "
CREATE TABLE ${TABLE}
(
  id SERIAL PRIMARY KEY,
  name TEXT
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
"
pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"
pg_execute "INSERT INTO ${TABLE} (name) VALUES('Collataral Portfolio');"


TABLE="%SCHEMA%.mcaattributes"
pg_execute "DROP TABLE IF EXISTS ${TABLE};"
pg_execute "
CREATE TABLE ${TABLE}
(
  mcaid integer NOT NULL,
  tag integer NOT NULL,
  value TEXT
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
"
pg_execute "CREATE INDEX mcaattributes_mca_idx ON ${TABLE} (mcaid);"
pg_execute "CREATE INDEX mcaattributes_tag_value_idx ON ${TABLE} (tag,value);"
pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"

