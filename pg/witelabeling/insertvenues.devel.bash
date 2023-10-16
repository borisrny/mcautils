#!/bin/bash

# Local
USER='postgres'
PASSWD='xxx'
DB='user2pg'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'


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



URL_API_BASE='http://127.0.0.1:5000'

VENUE='GFENY'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (1, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}'
]::json[]
);
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

VENUE='MONEYLI'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (2, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}'
]::json[]
);
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


VENUE='SLC'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (3, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}'
]::json[]
);
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"




VENUE='LENDORA'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (4, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"${URL_API_BASE}\",
      \"header\": {
        \"ApiKey\" : \"xxx\",
        \"UserName\": \"xxx\",
        \"Password\": \"xxx\"
		  }
	  }
}'
]::json[]
);
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

