#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


pg_execute "INSERT INTO userrole (name, property_name) VALUES ('ExternalCPA', 'role_extern_cpa');"
