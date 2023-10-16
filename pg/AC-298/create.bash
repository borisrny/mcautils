#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="commissionsmismatch"

pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${TABLE};"
pg_execute "
CREATE TABLE %SCHEMA%.${TABLE}
(
  mcaid integer NOT NULL,
  legal_name character varying,
  userid integer NOT NULL,
  expected_commission double precision,
  sent_commission double precision,
  expected_extrapoints double precision,
  sent_extrapoints double precision,
  active_count integer NOT NULL,
  total_amount double precision,
  has_mismatch boolean,
  suppress boolean,
  PRIMARY KEY (mcaid, userid)
)
TABLESPACE pg_default;
"


pg_execute "
DROP INDEX IF EXISTS %SCHEMA%.${TABLE}_mcaid_idx;

CREATE INDEX ${TABLE}_mcaid_idx
    ON %SCHEMA%.${TABLE} USING btree
    (mcaid ASC NULLS LAST)
    TABLESPACE pg_default;
"

pg_execute "ALTER TABLE %SCHEMA%.${TABLE} OWNER to %OWNER%;"
