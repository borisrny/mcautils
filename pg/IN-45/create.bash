#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

TABLE_NAME=docusignstatus
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${TABLE_NAME}"
pg_execute "CREATE TABLE %SCHEMA%.${TABLE_NAME} (
  offerid INTEGER,
  envelopeid TEXT,
  created_at TIMESTAMP with time zone DEFAULT NOW(),
  updated_at TIMESTAMP with time zone DEFAULT NOW(),
  CONSTRAINT fk_offerid FOREIGN KEY(offerid) REFERENCES %SCHEMA%.mcaoffer(id)
);"

pg_execute "
  CREATE INDEX docusignstatus_envelopeid_idx ON %SCHEMA%.${TABLE_NAME} (envelopeid);
"
