#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="mcastatus"
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.mcaposition;"
pg_execute "DROP TABLE IF EXISTS ${TABLE};"
pg_execute "
CREATE TABLE ${TABLE}
(
  id SERIAL PRIMARY KEY,
  status TEXT,
  category TEXT,
  property_name TEXT
)
"
pg_execute "CREATE UNIQUE INDEX mcastatus_property_name_idx ON ${TABLE} (property_name)"
pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"
pg_execute "INSERT INTO ${TABLE} VALUES(0, 'Unknown', 'Other', 'mca_status_unknown');"


TABLE="mcaprogram"
pg_execute "DROP TABLE IF EXISTS ${TABLE};"
pg_execute "
CREATE TABLE ${TABLE}
(
  id SERIAL PRIMARY KEY,
  name TEXT,
  property_name TEXT
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
"
pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Deal', 'mcaprogram_deal');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Consolidation', 'mcaprogram_consolidation');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Incremental', 'mcaprogram_incremental');"


TABLE="mcapaymentstatus"
pg_execute "DROP TABLE IF EXISTS ${TABLE};"
pg_execute "
CREATE TABLE ${TABLE}
(
  id SERIAL PRIMARY KEY,
  name TEXT,
  property_name TEXT
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
"
pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('', 'mcapaymentstatus_none');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Completed', 'mcapaymentstatus_completed');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Paying', 'mcapaymentstatus_paying');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Modified', 'mcapaymentstatus_modified');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Modified-Custom', 'mcapaymentstatus_modified_custom');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Non-Paying', 'mcapaymentstatus_non_paying');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Lawyer-Paying', 'mcapaymentstatus_lawyer_paying');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Lawyer-Non-Paying', 'mcapaymentstatus_lawyer_non_paying');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Settlement', 'mcapaymentstatus_settlement');"
pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Bankruptcy', 'mcapaymentstatus_bankruptcy');"
# pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Settlement (Lawyer)', 'mcapaymentstatus_settlement_lawyer');"
# pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Settlement (Internal)', 'mcapaymentstatus_settlement_internal');"
# pg_execute "INSERT INTO ${TABLE} (name, property_name) VALUES('Settlement (3rd Party)', 'mcapaymentstatus_settlement_3rd_party');"


# I want status in this table but might be too much to swallow in this phase
TABLE="%SCHEMA%.mcaposition"
pg_execute "DROP TABLE IF EXISTS ${TABLE};"
pg_execute "
CREATE TABLE ${TABLE}
(
  mcaid integer NOT NULL,
  status integer NOT NULL,
  status_reason_id integer,
  payment_status integer default 1,
  program integer default 1,
  funding_amount numeric(14,2) default 0,
  fee_pct double precision default 0,
  payment_amount numeric(14,2) default 0,
  payment_freq integer default 1,
  deposit_freq integer default 1,
  create_timestamp timestamp with time zone default CURRENT_TIMESTAMP,

  CONSTRAINT mcaposition__mcaprogram__fk FOREIGN KEY (program)
        REFERENCES public.mcaprogram (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
        NOT VALID,
  CONSTRAINT mcaposition__paymentstatus__fk FOREIGN KEY (payment_status)
        REFERENCES public.mcapaymentstatus (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
        NOT VALID,
  CONSTRAINT mcaposition__status__fk FOREIGN KEY (status)
        REFERENCES public.mcastatus (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
        NOT VALID
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
"
pg_execute "CREATE UNIQUE INDEX mcaposition_mcaid_idx ON ${TABLE} (mcaid)"
pg_execute "CREATE INDEX mcaposition_status_idx ON ${TABLE} USING btree (status) TABLESPACE pg_default;"
pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"


TABLE='%SCHEMA%.mcarate'
pg_execute "
DROP TABLE IF EXISTS ${TABLE};
create TABLE ${TABLE}
(
  id SERIAL PRIMARY KEY,
  mcaid integer NOT NULL,
  rate double precision default 1,
  current boolean NOT NULL,
  rate_type integer NOT NULL,
  expiry DATE default NULL
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
CREATE INDEX mcarate_mcaid_idx ON ${TABLE} USING btree (mcaid) TABLESPACE pg_default;
CREATE UNIQUE INDEX mcarate_mcaid_type_idx ON ${TABLE} (mcaid, rate_type)
"
pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"

#rate_type
#1 - contract
#2 - discount
