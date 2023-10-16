#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE %SCHEMA%.commissionoffer ADD created_at timestamp with time zone DEFAULT now()"
pg_execute "UPDATE %SCHEMA%.commissionoffer SET created_at=NULL"
pg_execute "ALTER TABLE %SCHEMA%.mcacommisionuser ADD created_at timestamp with time zone DEFAULT now()"
pg_execute "UPDATE %SCHEMA%.mcacommisionuser SET created_at=NULL"
