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


SCHEMA='gfeny'

TABLE='businessevent'
echo ${TABLE}
SQL="CREATE INDEX subject_idx ON ${SCHEMA}.${TABLE} (subject_id, subject_type);"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"

SQL="CREATE INDEX assignee_idx ON ${SCHEMA}.${TABLE} (assignee_id, assignee_type);"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"
