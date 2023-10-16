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




SQL="select * from industry"
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > industry

