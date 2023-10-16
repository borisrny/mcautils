#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


TABLE="public.loan_styles"

pg_execute "
DROP TABLE IF EXISTS ${TABLE};
"

pg_execute "
CREATE TABLE IF NOT EXISTS ${TABLE}
(
    id SERIAL NOT NULL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL,
    property_name CHARACTER VARYING NOT NULL
);"

pg_execute "INSERT INTO ${TABLE} (property_name, name) VALUES ('interest_only', 'Interest Only');"

pg_execute "INSERT INTO paymentperiod(name, property_name) VALUES
  ('last day of month',      'paymentperiod_last_day_of_month'),
  ('first day of month',      'paymentperiod_first_day_of_month');
"
