#!/bin/bash


SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

echo "$SCRIPT_PATH"

PG_ENV="$1"
source "$SCRIPT_PATH/pg_util.bash"

TABLE="%SCHEMA%.businessevent"

pg_execute "ALTER TABLE %SCHEMA%.businessevent ADD parent_id INT"
pg_execute "UPDATE %SCHEMA%.businessevent SET batch_id=id WHERE batch_id=0"
