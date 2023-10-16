#!/bin/bash

# Local
#USER='postgres'
#PASSWD='xxx'
#DB='user2pg'
#HOST='localhost'
#SCHEMA='gfeny'
#OWNER='postgres'
#

#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'


MID=1626
ED='8/13/2019'

for i in {1..1}
do
  SQL="insert into gfeny.transaction (mcaid,ammount,status,externstatus,effectivedate,transtype)
  values (${MID},35,14,'Returned','{$ED}',2)"
  echo ${SQL}
  PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"
done
