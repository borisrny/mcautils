#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/pg_util.bash"

pg_execute "ALTER TABLE userrole ADD COLUMN IF NOT EXISTS property_name character varying"
pg_execute "UPDATE userrole SET property_name='role_admin' WHERE id=1"
pg_execute "UPDATE userrole SET property_name='role_iso_relations' WHERE id=2"
pg_execute "UPDATE userrole SET property_name='role_Lender' WHERE id=3"
pg_execute "UPDATE userrole SET property_name='role_Underwriter' WHERE id=4"
pg_execute "UPDATE userrole SET property_name='role_iso' WHERE id=5"
pg_execute "UPDATE userrole SET property_name='role_mca_user' WHERE id=6"
pg_execute "UPDATE userrole SET property_name='role_accounting' WHERE id=7"
pg_execute "UPDATE userrole SET property_name='role_collection' WHERE id=8"
pg_execute "UPDATE userrole SET property_name='role_OfficeManager' WHERE id=9"
pg_execute "UPDATE userrole SET property_name='role_dataentry' WHERE id=10"
pg_execute "UPDATE userrole SET property_name='role_mcawfdashboard' WHERE id=11"
pg_execute "UPDATE userrole SET property_name='role_accounting_extern' WHERE id=12"
pg_execute "UPDATE userrole SET property_name='role_underwriter_limited' WHERE id=13"
pg_execute "UPDATE userrole SET property_name='role_FUT_INC_PREPARER' WHERE id=14"
pg_execute "UPDATE userrole SET property_name='role_FUT_INC_MAKER' WHERE id=15"
pg_execute "UPDATE userrole SET property_name='role_FUT_INC_CHECKER' WHERE id=16"

pg_execute "ALTER TABLE loginstatus ADD COLUMN IF NOT EXISTS property_name character varying"
pg_execute "UPDATE loginstatus SET property_name='login_stat_active' WHERE id=1"
pg_execute "UPDATE loginstatus SET property_name='login_stat_inactive' WHERE id=2"
pg_execute "UPDATE loginstatus SET property_name='login_stat_confirmed' WHERE id=3"
pg_execute "UPDATE loginstatus SET property_name='login_stat_deleted' WHERE id=4"
pg_execute "UPDATE loginstatus SET property_name='login_stat_locked' WHERE id=5"