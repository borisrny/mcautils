#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "ALTER TABLE mcadoccategory RENAME TO doccategory;"
pg_execute "ALTER TABLE doccategory ADD COLUMN doc_ref_type_id INT;"
pg_execute "UPDATE doccategory SET doc_ref_type_id=(SELECT id FROM doc_ref_type WHERE name='mca');"
pg_execute "ALTER TABLE doccategory ALTER COLUMN doc_ref_type_id SET NOT NULL;"
pg_execute "ALTER TABLE doccategory ADD CONSTRAINT doc_ref_type_fk FOREIGN KEY (doc_ref_type_id) REFERENCES doc_ref_type (id);"
