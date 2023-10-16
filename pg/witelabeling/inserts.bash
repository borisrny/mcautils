#!/bin/bash

# Local
USER='postgres'
PASSWD='xxx'
DB='user2pg'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'

#UAT2
#USER='gfedevel'
#PASSWD='93*Y$WK9CXMvG@oFJ+-J9CNs'
#DB='gfeusermigrate'
#HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
#SCHEMA='gfeny'
#OWNER='gfedevel'


TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('SLC', 'SLC');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('LENDORA', 'LENDORA');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"
