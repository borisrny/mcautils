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

TABLE='businesseventsubjecttype'
echo ${TABLE}
SQL="INSERT INTO ${SCHEMA}.${TABLE} (description) VALUES('Transaction');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"


SCHEMA='gfeny'

TABLE='businessevent'
echo ${TABLE}
SQL="ALTER TABLE ${SCHEMA}.${TABLE} ADD COLUMN note text;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"

