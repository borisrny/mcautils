#!/bin/bash

## Local
#USER='postgres'
#PASSWD='xxx'
#DB='user2pg'
#HOST='localhost'
#SCHEMA='gfeny'
#OWNER='postgres'
#
##UAT2
#USER='mcamaster'
#PASSWD='xxx'
#DB='gfeusermigrate'
#HOST='xxx'
#SCHEMA='gfeny'
#OWNER='gfedevel'

#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'

FN=export-sql
SQL="select id, mcaid, effectivedate, ammount, comment
from gfeny."transaction"
where externkey is null and status in (8,13) and transtype=2
and mcaid>0 and userid=0
and effectivedate > '01/01/2021';"

echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

