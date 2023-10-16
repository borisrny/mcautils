#!/bin/bash

PG_ENV="$1"
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"
pg_execute "INSERT INTO userrole (name, property_name) values ('Collateral Provider','role_collateral_provider')"
