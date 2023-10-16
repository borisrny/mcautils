#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


declare -a perm_list=(
    "user_financial_bankinfo"
    "user_financial_settings"
)

for perm_name in "${perm_list[@]}"
do
    pg_execute "INSERT INTO permission (permission, description) SELECT '$perm_name', '' WHERE NOT EXISTS (SELECT id FROM permission WHERE permission='$perm_name')"
done
