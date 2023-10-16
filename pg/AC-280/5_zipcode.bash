#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="zipcodes"
CSV_FILE="./mca_data/zip.csv"
if [ ! -f "${CSV_FILE}" ]; then
  echo "File ${CSV_FILE} was not found"
  exit 1
fi

pg_execute "DROP TABLE IF EXISTS ${TABLE};"

pg_execute "
CREATE TABLE IF NOT EXISTS ${TABLE}
(
    zipcode varchar(10) PRIMARY KEY,
    city character varying NOT NULL,
    state character varying NOT NULL,
    county character varying
)

TABLESPACE pg_default;
"

pg_execute "\COPY ${TABLE} (zipcode,city,state,county) FROM '${CSV_FILE}' WITH CSV HEADER;"
pg_execute "UPDATE zipcodes SET zipcode=lpad(zipcode, 5, '0');"

pg_execute "ALTER TABLE ${TABLE} OWNER to %OWNER%;"
