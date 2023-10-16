#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


TABLE="sent_documents"

pg_execute "
DROP TABLE IF EXISTS %SCHEMA%.${TABLE};
"

pg_execute "
CREATE TABLE IF NOT EXISTS %SCHEMA%.${TABLE}
(
    id SERIAL NOT NULL PRIMARY KEY,
    target CHARACTER VARYING NOT NULL,
    mcaid INTEGER,
    created_at TIMESTAMP with time zone DEFAULT NOW()
);"
