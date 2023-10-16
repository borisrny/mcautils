#!/bin/bash

# Local
USER='postgres'
PASSWD='xxx'
DB='user2pg'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'

#UAT2
#USER='mcamaster'
#PASSWD='xxx'
#DB='gfeusermigrate'
#HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
#SCHEMA='gfeny'
#OWNER='gfedevel'

#GFENY
#USER='mcamaster'
#PASSWD='xxx'
#DB='postgres'
#HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
#SCHEMA='gfeny'
#OWNER='mcamaster'


SCHEMA='public'


TABLE='businesseventaction'
echo ${TABLE}
TABLE_CREATE="
DROP TABLE IF EXISTS ${SCHEMA}.${TABLE};
create TABLE ${SCHEMA}.${TABLE}
(
  id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
  description character varying
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
alter table ${SCHEMA}.${TABLE} OWNER to ${OWNER};

INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('Assign');
INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('Complete');
INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('Un Assign');
INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('In Progress');
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"

TABLE='businesseventassigneetype'
echo ${TABLE}
TABLE_CREATE="
DROP TABLE IF EXISTS ${SCHEMA}.${TABLE};
create TABLE ${SCHEMA}.${TABLE}
(
  id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
  description character varying
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
alter table ${SCHEMA}.${TABLE} OWNER to ${OWNER};
INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('User');
INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('Role');
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"

TABLE='businesseventsubjecttype'
echo ${TABLE}
TABLE_CREATE="
DROP TABLE IF EXISTS ${SCHEMA}.${TABLE};
create TABLE ${SCHEMA}.${TABLE}
(
  id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
  description character varying
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
alter table ${SCHEMA}.${TABLE} OWNER to ${OWNER};
INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('MCA');
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"


SCHEMA='gfeny'


TABLE='businessevent'
echo ${TABLE}
TABLE_CREATE="
DROP TABLE IF EXISTS ${SCHEMA}.${TABLE};
create TABLE ${SCHEMA}.${TABLE}
(
  id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
  batch_id integer DEFAULT 0,
  create_ts timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  create_user integer,
  action integer,
  assignee_id integer,
  assignee_type integer,
  subject_id integer,
  subject_type integer,
  subject_action JSON
)
with ( OIDS = FALSE )
TABLESPACE pg_default;
alter table ${SCHEMA}.${TABLE} OWNER to ${OWNER};
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${TABLE_CREATE}"

