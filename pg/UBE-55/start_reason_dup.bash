#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE mcastatusreason ADD COLUMN IF NOT EXISTS tag character varying"
pg_execute "ALTER TABLE mcastatusreason ADD UNIQUE (tag)"
pg_execute "UPDATE mcastatusreason SET tag=replace(reason, ' ', '_')"
pg_execute "UPDATE mcastatusreason SET tag=lower(tag)"
pg_execute "UPDATE mcastatusreason SET tag=regexp_replace(tag, '\W', '', 'g')"
