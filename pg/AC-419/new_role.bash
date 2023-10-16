#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO userrole (name, property_name) VALUES('Account Change Fee', 'role_acctchange_fee');"
