#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE %SCHEMA%.bankacount ADD COLUMN ref_type INT"
pg_execute "UPDATE %SCHEMA%.bankacount SET ref_type=(SELECT id FROM doc_ref_type WHERE name='user')"
pg_execute "ALTER TABLE %SCHEMA%.bankacount ALTER COLUMN ref_type SET NOT NULL"
pg_execute "ALTER TABLE %SCHEMA%.bankacount ADD COLUMN ref_id INT"
pg_execute "UPDATE %SCHEMA%.bankacount a SET ref_id=(SELECT p.id FROM %SCHEMA%.person p WHERE a.id=ANY(p.bankrecs))"
pg_execute "ALTER TABLE %SCHEMA%.bankacount ALTER COLUMN ref_id SET NOT NULL"
pg_execute "ALTER TABLE %SCHEMA%.bankacount ADD COLUMN is_active BOOLEAN "
pg_execute "UPDATE %SCHEMA%.bankacount SET is_active=true"
pg_execute "ALTER TABLE %SCHEMA%.bankacount ALTER COLUMN is_active SET NOT NULL"
pg_execute "ALTER TABLE %SCHEMA%.bankacount ADD COLUMN is_default BOOLEAN"
pg_execute "UPDATE %SCHEMA%.bankacount a SET is_default=true"

### pg_execute "UPDATE %SCHEMA%.bankacount a SET is_default=(SELECT a.id=MAX(a2.id) FROM %SCHEMA%.bankacount a2 WHERE a2.ref_type=a.ref_type AND a2.ref_id=a.ref_id)"

pg_execute "ALTER TABLE %SCHEMA%.bankacount ALTER COLUMN is_default SET NOT NULL"
pg_execute "CREATE UNIQUE INDEX bankacount_unq ON %SCHEMA%.bankacount (ref_type, ref_id, is_default) WHERE (is_default=true)"

pg_execute "INSERT INTO doc_ref_type (id, name) SELECT 5, 'offer' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='offer')"
pg_execute "INSERT INTO doc_ref_type (id, name) SELECT 6, 'role' WHERE NOT EXISTS (SELECT id FROM doc_ref_type WHERE name='role')"
