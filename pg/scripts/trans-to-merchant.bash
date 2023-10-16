#!/bin/bash


#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



SQL="select mcaid, effectivedate, ammount from gfeny.transaction where status=13 and transtype in (5,6,7) and userid=0 order by mcaid"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" -A -F"," > to-merchant.csv

