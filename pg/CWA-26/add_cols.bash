#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE %SCHEMA%.offertemplate ADD COLUMN IF NOT EXISTS deposit_freq int, ADD COLUMN IF NOT EXISTS max_funding_amount numeric(14,2), ADD COLUMN IF NOT EXISTS max_exposure numeric(14,2), ADD COLUMN IF NOT EXISTS increments int[]"

pg_execute "ALTER TABLE industry ADD COLUMN IF NOT EXISTS max_withdrawal_rate numeric(8,5)"
