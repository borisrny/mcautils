#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "UPDATE transsubtype SET def='7500' WHERE subtype='Default Fee'"
pg_execute "UPDATE transsubtype SET def='5000' WHERE subtype='Stacking Fee'"
