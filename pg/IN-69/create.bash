#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

# alloc_type:
#   1 - implement as config venue mapping.
#   2,3 - allocation with venue replacement
#   4 - allocate entire payment to source venue investor and make payment from destination_dealvenue_id to syndicators.

TABLE_NAME=mca_transfer_account
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${TABLE_NAME}"
pg_execute "CREATE TABLE %SCHEMA%.${TABLE_NAME} (
  mca_id INTEGER PRIMARY KEY,
  alloc_type int,
  rtr_to_syndication DOUBLE PRECISION,
  destination_dealvenue_id INTEGER ,
  destination_investor_id INTEGER,
  source_dealvenue_id INTEGER ,
  source_investor_id INTEGER
);"

pg_execute "
ALTER TABLE %SCHEMA%.transrefrelation ALTER COLUMN ref_id TYPE bigint;
"

pg_execute "CREATE UNIQUE INDEX IF NOT EXISTS doc_ref_type_name_idx
    ON doc_ref_type USING btree
    (name ASC NULLS LAST);"

pg_execute "INSERT INTO doc_ref_type (name) VALUES ('trans_counterpart');"
pg_execute "INSERT INTO userrole (name, property_name) VALUES ('venue', 'role_venue');"

