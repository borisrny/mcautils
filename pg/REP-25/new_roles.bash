#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO userrole (name, property_name) VALUES('Ext Lawyer', 'role_ext_lawyer'), ('Ext Debt Stlmt', 'role_ext_debt_stlmt');"
