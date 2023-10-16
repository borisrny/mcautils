#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

if [[ $2 = "new" ]]; then
  pg_execute "DROP TABLE IF EXISTS paymentperiod"
  pg_execute "DROP TABLE IF EXISTS %SCHEMA%.contractloan"
  pg_execute "DROP TABLE IF EXISTS %SCHEMA%.transrefrelation"
fi

pg_execute "CREATE TABLE paymentperiod (
  id SERIAL PRIMARY KEY,
  name character varying NOT NULL,
  property_name character varying NOT NULL
);"

pg_execute "INSERT INTO paymentperiod(name, property_name) VALUES
  ('daily',      'paymentperiod_daily'),
  ('weekly',     'paymentperiod_weekly'),
  ('biweekly',   'paymentperiod_biweekly'),
  ('monthly',    'paymentperiod_monthly'),
  ('quarterly',  'paymentperiod_quarterly'),
  ('semiannual', 'paymentperiod_semiannual'),
  ('annual',     'paymentperiod_annual'),
  ('onetime',    'paymentperiod_onetime'),
  ('scheduled',  'paymentperiod_scheduled');"

pg_execute "INSERT INTO userrole (name, property_name) SELECT 'Loan Issuer', 'role_loan_issuer' WHERE NOT EXISTS (SELECT id FROM userrole WHERE property_name='role_loan_issuer');"

pg_execute "INSERT INTO transsubtype (subtype) SELECT 'Loan' WHERE NOT EXISTS (SELECT id FROM transsubtype WHERE subtype='Loan')"
pg_execute "INSERT INTO transsubtype (subtype) SELECT 'Interest' WHERE NOT EXISTS (SELECT id FROM transsubtype WHERE subtype='Interest')"
pg_execute "INSERT INTO transsubtype (subtype) SELECT 'Principal' WHERE NOT EXISTS (SELECT id FROM transsubtype WHERE subtype='Principal')"

pg_execute "CREATE TABLE %SCHEMA%.contractloan (
  id SERIAL PRIMARY KEY,
  contract_date date NOT NULL,
  maturity_date date NOT NULL,
  principal decimal(14, 2) NOT NULL,
  recruiter int,
  issuer_id int NOT NULL,
  coupon_rate double precision default 1,
  coupon_frequency int NOT NULL,
  principal_repayment_rate double precision default 0,
  venue_id int,
  create_user_id int NOT NULL,
  update_user_id int,
  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone
);"

pg_execute "CREATE TABLE %SCHEMA%.transrefrelation(
  trans_id bigint,
  ref_type int,
  ref_id int,
  PRIMARY KEY (trans_id, ref_type, ref_id)
);"
