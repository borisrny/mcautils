#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO transsubtype (subtype) SELECT 'Invoice' WHERE NOT EXISTS (SELECT id FROM transsubtype WHERE subtype='Invoice')"
