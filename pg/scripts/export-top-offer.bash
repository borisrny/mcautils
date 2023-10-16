#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD='xv7ob44qoQAh3wtWTPqpM=jB'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'

FN=export-top-offer
SQL="with ids as (select mcaid, max(id) as id from gfeny.mcaoffer group by mcaid)
select o.mcaid, o.amount, o.rates, o.withdrawal_payment
from gfeny.mcaposition p, gfeny.mcaoffer o, ids
where p.mcaid=o.mcaid and p.mcaid=ids.mcaid and o.id=ids.id and p.status=278"

echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

