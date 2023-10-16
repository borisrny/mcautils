#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="investoracceptstatus"

pg_execute "DROP TABLE IF EXISTS ${TABLE};"

pg_execute "
CREATE TABLE ${TABLE}
(
    id SERIAL PRIMARY KEY,
    name character varying,
    property_name character varying
)
with ( OIDS = FALSE ) TABLESPACE pg_default;"

pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"

pg_execute "
INSERT INTO ${TABLE} (name, property_name) VALUES('active', 'acceptstatus_active');
INSERT INTO ${TABLE} (name, property_name) VALUES('setup',  'acceptstatus_setup');
INSERT INTO ${TABLE} (name, property_name) VALUES('reject', 'acceptstatus_reject');
INSERT INTO ${TABLE} (name, property_name) VALUES('accept', 'acceptstatus_accept');
INSERT INTO ${TABLE} (name, property_name) VALUES('review', 'acceptstatus_review');
"

TABLE="%SCHEMA%.mcainvestors"

pg_execute "DROP TABLE IF EXISTS ${TABLE};"

pg_execute "
CREATE TABLE ${TABLE}
(
    id SERIAL PRIMARY KEY,
    mcaid integer,
    userid integer,
    status integer,
    mgmt_fee_base integer,
    part_pct float not null DEFAULT 0,
    bypayment_fee_pct float not null DEFAULT 0,
    upfront_fee_pct float not null DEFAULT 0,
    visible_docs integer ARRAY
)
with ( OIDS = FALSE ) TABLESPACE pg_default;"

pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"
pg_execute "CREATE INDEX mcainvestor_mcaid_idx ON ${TABLE} USING btree (mcaid);"
pg_execute "CREATE INDEX mcainvestor_userid_idx ON ${TABLE} USING btree (userid);"
#pg_execute "CREATE UNIQUE INDEX mcaid_userid_unique ON ${TABLE} (mcaid, userid);"
