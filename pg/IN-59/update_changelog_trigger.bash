#!/bin/bash

set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="%SCHEMA%.person"
pg_execute "ALTER TABLE ${TABLE} ADD COLUMN update_user INT;"
TABLE="%SCHEMA%.userdefaults"
pg_execute "ALTER TABLE ${TABLE} ADD COLUMN update_user INT;"
TABLE="%SCHEMA%.bankacount"
pg_execute "ALTER TABLE ${TABLE} ADD COLUMN update_user INT;"
