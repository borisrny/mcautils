#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


pg_execute "ALTER TABLE %SCHEMA%.mcadoc ADD is_temp BOOL NOT NULL DEFAULT false"
