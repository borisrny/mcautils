#!/bin/bash

# Local
USER='postgres'
PASSWD='xxx'
DB='gfeny'
HOST='localhost'
SCHEMA='public'
OWNER='postgres'

SCHEMA='public'

TABLE='holidays'
echo ${TABLE}
TABLE_CREATE="
create TABLE ${SCHEMA}.${TABLE}
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    date date NOT NULL,
    country character varying NOT NULL,
    unique (date, country)
);
alter table ${SCHEMA}.${TABLE} OWNER to ${OWNER};

"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"

echo ${TABLE_CREATE}

PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"
