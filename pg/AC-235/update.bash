#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


pg_execute "INSERT INTO userrole (name, property_name) VALUES ('monthly_admin_fee', 'role_monthly_admin_fee');"
pg_execute "INSERT INTO userrole (name, property_name) VALUES ('ucc_fee', 'role_ucc_fee');"
pg_execute "INSERT INTO userrole (name, property_name) VALUES ('wire_fee', 'role_wire_fee');"
pg_execute "INSERT INTO userrole (name, property_name) VALUES ('nsf_fee', 'role_nsf_fee');"
pg_execute "INSERT INTO userrole (name, property_name) VALUES ('default_fee', 'role_default_fee');"
pg_execute "INSERT INTO userrole (name, property_name) VALUES ('stacking_fee', 'role_stacking_fee');"


pg_execute "INSERT INTO transsubtype (subtype) VALUES ('Bonus');"

