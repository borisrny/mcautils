#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


pg_execute "INSERT INTO userrole (name, property_name) VALUES ('investor_fee', 'role_investor_fee');"
pg_execute "INSERT INTO transsubtype (subtype) VALUES ('RTR Fee');"
pg_execute "update public.transsubtype set def=45 where id=1;"
