#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE %SCHEMA%.transaction ADD COLUMN processing_venue INTEGER"
pg_execute ""
