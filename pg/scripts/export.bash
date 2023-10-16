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


TABLE='gfeny.transaction'
STATUS="status in (5,6,8,13)"
WCONTRACT="mcaid>0"

# To merchant
TRTYPE="transtype IN (5,6,7)"
FN="out/SentToMerchant.csv"
WHERE="${STATUS} and ${TRTYPE} and ${WCONTRACT}"
COLS='mcaid, effectivedate, ROUND(ammount::numeric, 2)'
SQL="select ${COLS} from ${TABLE} where ${WHERE} ORDER BY mcaid"
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

# Merchant Refunds
TRTYPE="transtype=9"
FN="out/MerchantRefunds.csv"
WHERE="${STATUS} and ${TRTYPE} and ${WCONTRACT}"
COLS='mcaid, effectivedate, ROUND(ammount::numeric, 2)'
SQL="select ${COLS} from ${TABLE} where ${WHERE} ORDER BY mcaid"
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

# Payments
TRTYPE="transtype IN (2,9)"
FN="out/PaymentsFromMerchant.csv"
WHERE="${STATUS} and ${TRTYPE} and ${WCONTRACT}"
COLS='mcaid, effectivedate, ROUND(ammount::numeric, 2)'
SQL="select ${COLS} from ${TABLE} where ${WHERE} ORDER BY mcaid"
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

# Commissions
TRTYPE="transtype=11"
FN="out/CommissionsByDeal.csv"
WHERE="${STATUS} and ${TRTYPE} and ${WCONTRACT}"
COLS='mcaid, effectivedate, ROUND(ammount::numeric, 2)'
SQL="select ${COLS} from ${TABLE} where ${WHERE} ORDER BY mcaid"
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}


# ContractFee
TRTYPE="transtype=16"
FN="out/ContractFee.csv"
WHERE="${STATUS} and ${TRTYPE} and ${WCONTRACT}"
COLS='mcaid, effectivedate, ROUND(ammount::numeric, 2)'
SQL="select ${COLS} from ${TABLE} where ${WHERE} ORDER BY mcaid"
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

