#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE %SCHEMA%.person ADD COLUMN created_at TIMESTAMP WITH TIME ZONE"
pg_execute "ALTER TABLE %SCHEMA%.person ALTER COLUMN created_at SET DEFAULT NOW()"
