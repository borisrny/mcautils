#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO businesseventtype(type, property_name, value) SELECT 'subject', 'mcaoffer', 3 
WHERE NOT EXISTS (SELECT id FROM businesseventtype WHERE type='subject' AND property_name='mcaoffer') "

pg_create_custom_type 'deposit_offer' 'CREATE TYPE deposit_offer as (quantity int, amount decimal(14,2), fee decimal(14,2));'
pg_create_custom_type 'withdrawal_offer' 'CREATE TYPE withdrawal_offer as (quantity int, amount decimal(14,2));'
pg_create_custom_type 'rate_offer' 'CREATE TYPE rate_offer as (rate decimal(8,5), expiry date);'

set +e
pg_execute "ALTER TABLE %SCHEMA%.mcaoffer RENAME TO mcaeml;"
set -e
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.advancesoffer;"
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.commissionoffer;"
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.mcaoffer"

pg_execute "DROP TABLE IF EXISTS mcaofferstatus"
pg_execute "CREATE TABLE mcaofferstatus (
  id SERIAL PRIMARY KEY,
  name character varying NOT NULL,
  property_name character varying NOT NULL
);"
pg_execute "INSERT INTO mcaofferstatus(name, property_name) VALUES
  ('New', 'new'),
  ('Sent to broker', 'sent'),
  ('Contract requested', 'contract_requested'),
  ('Contract out', 'contract_out'),
  ('Contract in', 'contract_in'),
  ('Contract in Exclusive', 'contract_in_exclusive'),
  ('Ready for funding', 'ready_for_funding'),
  ('Funded', 'funded'),
  ('Expired', 'expired')";


pg_execute "CREATE TABLE %SCHEMA%.mcaoffer (
  id SERIAL PRIMARY KEY,
  mcaid int NOT NULL,
  commissionset int,
  name character varying NOT NULL,
  funding_type int NOT NULL DEFAULT 1,
  amount decimal(14, 2) NOT NULL,
  rates rate_offer[],
  deposit_freq int NOT NULL DEFAULT 1,
  deposit deposit_offer[],
  withdrawal_freq int NOT NULL DEFAULT 1,
  withdrawal_payment decimal(14, 2),
  withdrawal withdrawal_offer[],
  contract_fee_pct decimal(8,5),
  ach_for_deposits boolean,
  ach_for_payments boolean,
  fixed_payment boolean,
  createuserid int,
  updateuserid int,
  sent_at timestamp with time zone,
  status int not null,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  CONSTRAINT fk_status FOREIGN KEY(status) REFERENCES mcaofferstatus(id)
);"

pg_execute "alter table %SCHEMA%.mcaoffer OWNER to %OWNER%;"
pg_execute "CREATE INDEX mcaoffer_created_at_idx ON %SCHEMA%.mcaoffer (created_at);"

pg_execute "CREATE TABLE IF NOT EXISTS %SCHEMA%.commissionoffer (
  id SERIAL PRIMARY KEY,
  offerid int NOT NULL,
  userid int NOT NULL,
  venueid int NOT NULL,
  percent decimal(8,5) NOT NULL,
  contract_fee decimal(8,5) NOT NULL,
  base_type int NOT NULL,
  paystrategy int NOT NULL,
  CONSTRAINT fk_offerid FOREIGN KEY(offerid) REFERENCES %SCHEMA%.mcaoffer(id)
);"

pg_execute "alter table %SCHEMA%.commissionoffer OWNER to %OWNER%;"


pg_execute "CREATE TABLE IF NOT EXISTS %SCHEMA%.advancesoffer(
  id SERIAL PRIMARY KEY,
  offerid int NOT NULL,
  name character varying NOT NULL,
  funding_date date,
  funding_amount decimal(14, 2) NOT NULL,
  balance_asof date,
  ignore_funding_date boolean,
  calc_date date,
  amount decimal(14, 2) NOT NULL,
  factor_rate decimal(8,5),
  payment decimal(14, 2),
  balance decimal(14, 2),
  consolidate boolean,
  buyout boolean,
  refmcaid int,
  CONSTRAINT fk_offerid FOREIGN KEY(offerid) REFERENCES %SCHEMA%.mcaoffer(id)
);"

pg_execute "alter table %SCHEMA%.advancesoffer OWNER to %OWNER%;"
