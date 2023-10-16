#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "DROP TABLE IF EXISTS %SCHEMA%.offertemplate;"

pg_execute "CREATE TABLE %SCHEMA%.offertemplate (
  id SERIAL PRIMARY KEY,
  name character varying NOT NULL,
  funding_type int NOT NULL,
  crate decimal(8, 5) NOT NULL,
  crate_days int NOT NULL,
  drate decimal(8, 5),
  drate_days int,
  contract_fee_pct decimal(8,5) NOT NULL,
  withdrawal_freq int NOT NULL DEFAULT 1,
  iso_commission_rtr_pct decimal(8, 5),
  iso_contract_fee_pct decimal(8, 5),
  isorep_commission_pct decimal(8, 5),
  isorep_contract_fee_pct decimal(8, 5),
  commission_comm_rtr_pct decimal(8, 5),
  commission_contract_fee_pct decimal(8, 5),
  ins_commission_rtr decimal(8, 5),
  ins_commission_contract_fee_pct decimal(8, 5),
  cf_commission_rtr_pct decimal(8, 5),
  cf_contract_fee_pct decimal(8, 5),
  created_at timestamp with time zone
);"

pg_execute "INSERT INTO %SCHEMA%.offertemplate(name, funding_type, crate, crate_days, drate,
drate_days, contract_fee_pct, withdrawal_freq, iso_commission_rtr_pct,
iso_contract_fee_pct, isorep_commission_pct, isorep_contract_fee_pct, commission_comm_rtr_pct,
commission_contract_fee_pct, ins_commission_rtr, ins_commission_contract_fee_pct,
cf_commission_rtr_pct, cf_contract_fee_pct, created_at) VALUES

('Position @1.44 (Daily) at 10% Fee, Paying 20 Points Comm',
1,     -- funding_type
1.44,  -- crate
100,   -- crate_days
1.44,  -- drate
100,   -- drate_days
10,    -- contract_fee_pct
1,     -- withdrawal_freq
14,    -- iso_commission_rtr_pct
6,     -- iso_contract_fee_pct
1,     -- isorep_commission_pct
0,     -- isorep_contract_fee_pct
1.5,   -- commission_comm_rtr_pct
0,     -- commission_contract_fee_pct
0.5,   -- ins_commission_rtr
0,     -- ins_commission_contract_fee_pct
0,     -- cf_commission_rtr_pct
0,     -- cf_contract_fee_pct
NOW()),

('Position @1.25 (Weekly) at 10% Fee, Paying 13 Points Comm',
1,     -- funding_type
1.35,  -- crate
14,    -- crate_days
1.25,  -- drate
13,    -- drate_days
10,    -- contract_fee_pct
5,     -- withdrawal_freq
7,     -- iso_commission_rtr_pct
6,     -- iso_contract_fee_pct
0.5,   -- isorep_commission_pct
0,     -- isorep_contract_fee_pct
0.5,   -- commission_comm_rtr_pct
0,     -- commission_contract_fee_pct
0,     -- ins_commission_rtr
0,     -- ins_commission_contract_fee_pct
0,     -- cf_commission_rtr_pct
0,     -- cf_contract_fee_pct
NOW()),

('Position @1.25 (Daily) at 10% Fee, Paying 13 Points Comm',
1,     -- funding_type
1.35,  -- crate
68,    -- crate_days
1.25,  -- drate
63,    -- drate_days
10,    -- contract_fee_pct
1,     -- withdrawal_freq
7,     -- iso_commission_rtr_pct
6,     -- iso_contract_fee_pct
0.5,   -- isorep_commission_pct
0,     -- isorep_contract_fee_pct
0.5,   -- commission_comm_rtr_pct
0,     -- commission_contract_fee_pct
0,     -- ins_commission_rtr
0,     -- ins_commission_contract_fee_pct
0,     -- cf_commission_rtr_pct
0,     -- cf_contract_fee_pct
NOW()),

('Consolidation @1.44 (Daily) at 0% Fee, Paying 17 Points Comm',
2,     -- funding_type
1.44,  -- crate
150,   -- crate_days
1.44,  -- drate
150,   -- drate_days
0,     -- contract_fee_pct
1,     -- withdrawal_freq
14,    -- iso_commission_rtr_pct
3,     -- iso_contract_fee_pct
1,     -- isorep_commission_pct
0,     -- isorep_contract_fee_pct
1.5,   -- commission_comm_rtr_pct
0,     -- commission_contract_fee_pct
0.5,   -- ins_commission_rtr
0,     -- ins_commission_contract_fee_pct
4,     -- cf_commission_rtr_pct
0,     -- cf_contract_fee_pct
NOW())
;"
