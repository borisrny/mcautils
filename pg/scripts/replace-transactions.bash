#!/bin/bash

#TABLES=['gfeny.transaction', 'gfeny.transcrosref', 'gfeny.transrelated']
TABLES=('transaction' 'transcrosref' 'transrelated')

#copy from remote
#R_USER='mcamaster'
#R_PWD=''
#R_DB='postgres'
#R_HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
#for t in ${TABLES[@]}; do
#    echo $t
#    PGPASSWORD=${R_PWD} psql -h ${R_HOST} -U ${R_USER} -d ${R_DB} -c "\copy gfeny.${t} TO '${t}.csv' delimiter '|' CSV HEADER;"
#done


# copy to
L_USER='postgres'
L_DB='user2pg'
L_HOST='localhost'
L_PWD=''
for t in ${TABLES[@]}; do
    echo $t
    PGPASSWORD=${L_PWD} psql -h ${L_HOST} -U ${L_USER} -d ${L_DB} -c "truncate table gfeny.${t};"
done
for t in ${TABLES[@]}; do
    echo $t
    PGPASSWORD=${L_PWD} psql -h ${L_HOST} -U ${L_USER} -d ${L_DB} -c "\copy gfeny.${t} FROM '${t}.csv' delimiter '|' CSV HEADER;"
done


