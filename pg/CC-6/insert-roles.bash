#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


#pg_execute "INSERT INTO userrole (name, property_name) VALUES ('commission', 'role_commission');"
#pg_execute "INSERT INTO userrole (name, property_name) VALUES ('commission_insurance', 'role_commission_insurance');"

pg_execute "UPDATE userrole SET name='ins_commission', property_name='role_ins_commission' WHERE property_name='role_commission_insurance'"
pg_execute "INSERT INTO userrole (name, property_name) VALUES ('contract_fee', 'role_contract_fee');"

