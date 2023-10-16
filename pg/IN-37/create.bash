#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"


TABLE_NAME=portfolio_snap_exposure
pg_execute "DROP TABLE IF EXISTS  %SCHEMA%.${TABLE_NAME}"
pg_execute "CREATE TABLE  %SCHEMA%.${TABLE_NAME} (
  mcaid integer PRIMARY KEY,
  eff_fund_amt double precision default 0,
  eff_exposure double precision default 0,
  eff_exposure_with_com double precision default 0,
  update_ts  timestamp with time zone
);"

pg_execute "alter table %SCHEMA%.${TABLE_NAME} OWNER to %OWNER%;"
