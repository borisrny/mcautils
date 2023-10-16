#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "DROP TABLE IF EXISTS %SCHEMA%.mca_contract_changes"

pg_execute "CREATE TABLE %SCHEMA%.mca_contract_changes
(
  mcaid integer NOT NULL PRIMARY KEY,
  rate_type integer,
  payment_amount numeric(14,2),
  payment_frequency integer,           -- should have other name
  created_at timestamp with time zone
)"
