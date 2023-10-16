#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "CREATE TABLE IF NOT EXISTS %SCHEMA%.authlog (
  id SERIAL PRIMARY KEY,
  userid character varying,
  ip_addr character varying,
  event character varying,
  created_at timestamp with time zone DEFAULT now()
);"
