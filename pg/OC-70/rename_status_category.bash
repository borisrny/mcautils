#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "UPDATE mcastatus SET category='Accounting Department' WHERE category='Performing'; "
pg_execute "UPDATE mcastatus SET category='Final Underwriting Department' WHERE category='Underwriting'; "
pg_execute "UPDATE mcastatus SET category='Pricing Department' WHERE category='Decline'; "
pg_execute "UPDATE mcastatus SET category='Calculation Department' WHERE category='ACH/NACHA'; "
pg_execute "UPDATE mcastatus SET category='Data Processing Department' WHERE category='ACH/NACHA Billing'; "
