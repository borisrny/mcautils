#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO doc_ref_type (name) SELECT 'ext_collector' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='ext_collector')"
pg_execute "INSERT INTO doc_ref_type (name) SELECT 'int_collector' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='int_collector')"
pg_execute "INSERT INTO doc_ref_type (name) SELECT 'ext_lawyer' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='ext_lawyer')"

pg_execute "ALTER TABLE %SCHEMA%.transrefrelation DROP CONSTRAINT transrefrelation_pkey"
pg_execute "CREATE INDEX transrefrelation_trans_id_idx ON %SCHEMA%.transrefrelation (trans_id)"
pg_execute "CREATE INDEX transrefrelation_ref_type_ref_id_idx ON %SCHEMA%.transrefrelation (ref_type, ref_id)"
pg_execute "ALTER TABLE %SCHEMA%.transrefrelation ALTER ref_id DROP NOT NULL"
