#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO public.transsubtype (subtype) VALUES('Contract Fee')"

pg_execute "ALTER TABLE %SCHEMA%.mcacommisionuser ADD COLUMN cfcomm_on_last_incr boolean NOT NULL DEFAULT False;"
pg_execute "COMMENT ON COLUMN %SCHEMA%.mcacommisionuser.cfcomm_on_last_incr IS 'Indicates that contract fee portion of commissions has to be allocated on the last increment';"
