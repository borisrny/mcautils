#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

Q_TABLE="questions"

pg_execute "UPDATE %SCHEMA%.${Q_TABLE} SET question = REPLACE(question, 'GFE', '\${venue}');"
