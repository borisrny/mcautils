#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="questions"

pg_execute "UPDATE %SCHEMA%.${TABLE} SET tag = 'consolidationAndIncrementalACH' WHERE tag = 'consolidationACH'"
