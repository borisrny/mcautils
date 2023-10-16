#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO doc_ref_type (id, name) SELECT 5, 'offer' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='offer')"
pg_execute "INSERT INTO doc_ref_type (id, name) SELECT 6, 'role' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='role')"
pg_execute "INSERT INTO doc_ref_type (id, name) SELECT 7, 'pm' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='pm')"
