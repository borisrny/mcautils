#!/bin/bash


#GFENY
USER='mcamaster'
PASSWD='xv7ob44qoQAh3wtWTPqpM=jB'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



SQL="select b.mcaid, b.mcastatus, b.pay_status, b.start_date, b.last_payment_date, b.transaction_balance from gfeny.portfoliosnap b;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > portfbalances.csv

