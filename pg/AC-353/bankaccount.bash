#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE %SCHEMA%.bankacount ADD COLUMN description character varying"
pg_execute "ALTER TABLE %SCHEMA%.bankacount RENAME TO bankaccount"
