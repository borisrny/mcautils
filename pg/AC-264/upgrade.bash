#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO public.transtype (type, direction) VALUES('Non ACH Pmnt', 2)"
pg_execute "INSERT INTO public.transsubtype (subtype) VALUES('Non ACH Fee')"
