#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

AR_TABLE="user_account_receivable"

pg_execute "
ALTER TABLE %SCHEMA%.${AR_TABLE}
  ADD COLUMN IF NOT EXISTS update_timestamp TIMESTAMP WITH TIME ZONE,
  ADD COLUMN IF NOT EXISTS update_user INTEGER"

pg_execute "UPDATE %SCHEMA%.${AR_TABLE} SET update_user = 0, update_timestamp = NOW()"

pg_execute "
ALTER TABLE %SCHEMA%.${AR_TABLE}
  ALTER COLUMN update_timestamp SET NOT NULL,
  ALTER COLUMN update_user SET NOT NULL"

MCAREF_TABLE="mcarefuser"

pg_execute "
ALTER TABLE %SCHEMA%.${MCAREF_TABLE}
  ADD COLUMN IF NOT EXISTS update_timestamp TIMESTAMP WITH TIME ZONE,
  ADD COLUMN IF NOT EXISTS update_user INTEGER,
  ADD COLUMN IF NOT EXISTS status INTEGER,
  ADD COLUMN IF NOT EXISTS amount DOUBLE PRECISION DEFAULT 0.0,
  ADD COLUMN IF NOT EXISTS note TEXT"

# status (1) is active
pg_execute "UPDATE %SCHEMA%.${MCAREF_TABLE} SET status = 1, amount = 0.0, update_user = 0, update_timestamp = NOW()"

pg_execute "
ALTER TABLE %SCHEMA%.${MCAREF_TABLE}
  ALTER COLUMN status SET NOT NULL,
  ALTER COLUMN update_timestamp SET NOT NULL,
  ALTER COLUMN update_user SET NOT NULL"

P_TABLE="person"
pg_execute "ALTER TABLE %SCHEMA%.${P_TABLE} ADD COLUMN IF NOT EXISTS is_full_contract_to_send BOOLEAN DEFAULT TRUE"
