#!/bin/bash


#GFENY
USER='mcamaster'
PASSWD='xv7ob44qoQAh3wtWTPqpM=jB'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



SQL="select pr.id, pr.lastname, pr.firstname, pr.fullname, lg.roles from gfeny.person pr, gfeny.login lg
where lg.personid = pr.id;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > usernames.csv

