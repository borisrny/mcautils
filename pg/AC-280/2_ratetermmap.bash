#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="ratetermmap"
CSV_FILE="rateTermMap.csv"
if [ ! -f "${CSV_FILE}" ]; then
  echo "File ${CSV_FILE} was not found"
  exit 1
fi

pg_execute "DROP TABLE IF EXISTS ${TABLE};"

pg_execute "
CREATE TABLE IF NOT EXISTS ${TABLE}
(
    id SERIAL NOT NULL PRIMARY KEY,
    \"count\" INTEGER NOT NULL,
    factor_rate NUMERIC(5, 2) NOT NULL,
    term INTEGER NOT NULL
)

TABLESPACE pg_default;
"

pg_execute "\COPY ${TABLE} (id, \"count\", factor_rate, term) FROM '${CSV_FILE}' WITH CSV HEADER;"

pg_execute "SELECT setval(pg_get_serial_sequence('${TABLE}', 'id'), coalesce(max(id), 0)) FROM ${TABLE};"

pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"
