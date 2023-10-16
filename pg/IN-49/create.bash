#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

R_TABLE_NAME=external_document_recipients_status
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${R_TABLE_NAME}"

D_TABLE_NAME=external_documents_status
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${D_TABLE_NAME}"
pg_execute "CREATE TABLE %SCHEMA%.${D_TABLE_NAME} (
  id SERIAL PRIMARY KEY,
  offer_id INTEGER,
  source_type INTEGER NOT NULL,                   -- enum ex. docusign
  external_key CHARACTER VARYING NOT NULL UNIQUE, -- external key to link offer to specific record on external service
  status INTEGER NOT NULL,                        -- document signature status
  extra_data JSON,                                -- extra data needs to keep additional data, ex. links to get document status, dependent data to this offer
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_external_documents_status_offer_id FOREIGN KEY(offer_id) REFERENCES %SCHEMA%.mcaoffer(id)
);"

pg_execute "
  CREATE INDEX external_documents_status_document_id_source_type_idx ON %SCHEMA%.${D_TABLE_NAME} (offer_id, source_type);
  CREATE INDEX external_documents_status_external_key_idx ON %SCHEMA%.${D_TABLE_NAME} (external_key);
"

pg_execute "CREATE TABLE %SCHEMA%.${R_TABLE_NAME} (
  id SERIAL PRIMARY KEY,
  external_document_id INTEGER NOT NULL,
  person_id INTEGER,
  external_key CHARACTER VARYING UNIQUE,  -- external key to link user to specific record on external service
  status INTEGER NOT NULL,                -- document signature status for this user
  extra_data JSON,                        -- extra data needs to keep additional data, ex. links to get document status, dependent data to this offer
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_external_document_recipients_status_external_document_id FOREIGN KEY(external_document_id) REFERENCES %SCHEMA%.external_documents_status(id)
);"

pg_execute "
  CREATE INDEX external_document_recipients_status_external_key_idx ON %SCHEMA%.${R_TABLE_NAME} (external_key);
"

# Copy data from docusignstatus table into new
pg_execute "
  INSERT INTO %SCHEMA%.external_documents_status (source_type, offer_id, external_key, status) SELECT 1, offerid, envelopeid, 8 FROM %SCHEMA%.docusignstatus;
"

# Drop docusignstatus table
pg_execute "
  DROP TABLE IF EXISTS %SCHEMA%.docusignstatus;
"