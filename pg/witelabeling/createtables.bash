#!/bin/bash

# Local
#USER='postgres'
#PASSWD='xxx'
#DB='user2pg'
#HOST='localhost'
#SCHEMA='gfeny'
#OWNER='postgres'

#UAT2
USER='mcamaster'
PASSWD='xxx'
DB='gfeusermigrate'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='gfedevel'

#GFENY
USER='mcamaster'
PASSWD='xxx'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'


TABLE='dealvenue'
echo ${TABLE}
TABLE_CREATE="\
DROP TABLE IF EXISTS ${SCHEMA}.${TABLE};
create TABLE ${SCHEMA}.${TABLE} \
( \
  id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ), \
  code character varying, \
  description character varying \
) \
with ( OIDS = FALSE ) \
TABLESPACE pg_default; \
alter table ${SCHEMA}.${TABLE} OWNER to ${OWNER}; \

CREATE UNIQUE INDEX dealvenue_code_idx \
    ON ${SCHEMA}.${TABLE} USING btree \
    (code COLLATE pg_catalog."default" ASC NULLS LAST) \
    TABLESPACE pg_default; \
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"


TABLE='achvenue'
echo ${TABLE}
TABLE_CREATE="\
DROP TABLE IF EXISTS ${SCHEMA}.${TABLE}; \
CREATE TABLE ${SCHEMA}.${TABLE} \
( \
  id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ), \
    dealvenueid integer NOT NULL, \
    code character varying COLLATE pg_catalog."default" NOT NULL, \
    description character varying COLLATE pg_catalog."default" NOT NULL, \
    targetconnoverride character varying, \
    achprocessors json[], \
    CONSTRAINT achvenue_pkey PRIMARY KEY (id) \
) \
WITH ( \
    OIDS = FALSE \
) \
TABLESPACE pg_default; \
alter table ${SCHEMA}.${TABLE} OWNER to ${OWNER}; \
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"

TABLE='transaction'
echo ${TABLE}
ADD_COL="ALTER TABLE ${SCHEMA}.${TABLE} ADD COLUMN IF NOT EXISTS dealvenue integer NOT NULL DEFAULT 1;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${ADD_COL}"

TABLE='userdefaults'
echo ${TABLE}
ADD_COL="ALTER TABLE ${SCHEMA}.${TABLE} ADD COLUMN IF NOT EXISTS dealvenue integer NOT NULL DEFAULT 1;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${ADD_COL}"

TABLE='mcacommisionuser'
echo ${TABLE}
ADD_COL="ALTER TABLE ${SCHEMA}.${TABLE} ADD COLUMN IF NOT EXISTS dealvenue integer NOT NULL DEFAULT 1;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${ADD_COL}"



TABLE='transaction'
echo ${TABLE}
UPDATE_COL="UPDATE ${SCHEMA}.${TABLE} SET dealvenue=1;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${UPDATE_COL}"