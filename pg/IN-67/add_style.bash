#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


TABLE="contractloan"

pg_execute "ALTER TABLE %SCHEMA%.${TABLE} ADD COLUMN loan_style_id INT default 1;"
pg_execute "ALTER TABLE %SCHEMA%.${TABLE} ADD CONSTRAINT fk_loan_style FOREIGN KEY (loan_style_id) REFERENCES public.loan_styles (id);"
