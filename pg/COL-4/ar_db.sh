#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

if [[ $2 = "new" ]]; then
  pg_execute "DROP TABLE IF EXISTS %SCHEMA%.user_account_receivable"
  pg_execute "DROP TABLE IF EXISTS %SCHEMA%.mcarefuser"
fi

pg_execute "INSERT INTO userrole (name, property_name) SELECT 'Account Receivable', 'role_account_receivable' WHERE NOT EXISTS (SELECT id FROM userrole WHERE property_name='role_account_receivable');"

pg_execute "CREATE TABLE %SCHEMA%.user_account_receivable (
  user_id INT PRIMARY KEY,
  distribution_criteria INT,
  industry INT[],
  is_active BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES %SCHEMA%.person(id)
);"

pg_execute "CREATE TABLE %SCHEMA%.mcarefuser (
    mca_id INT,
    user_id INT,
    PRIMARY KEY(mca_id, user_id),
    CONSTRAINT fk_mcaid FOREIGN KEY (mca_id) REFERENCES %SCHEMA%.mcaposition(mcaid),
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES %SCHEMA%.person(id)
);"
