#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="collateralrequirements"

pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${TABLE};"
pg_execute "
CREATE TABLE %SCHEMA%.${TABLE}
(
  collateral_tag character varying,
  balance_received double precision,
  minimum_value double precision,
  unique(collateral_tag)
)
TABLESPACE pg_default;
"



pg_execute "ALTER TABLE %SCHEMA%.${TABLE} OWNER to %OWNER%;"
