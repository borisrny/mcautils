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
#HOST=''
#SCHEMA='gfeny'
#OWNER='gfedevel'

#GFENY
USER='mcamaster'
PASSWD='xxxx'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'


# Payments to ISO/IDO relation
FN='out/ISOCommissions.csv'
SQL='select tr."id", tr.mcaref, tr.effectivedate, tr.ammount, pr.lastname, pr.firstname, pr.fullname
from gfeny."transaction" tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype=2 and tr.status in (8,13)
and tr.userid=lgn.personid
and (5=any(lgn.roles) or 2=any(lgn.roles));'
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

# ISO/ISO relation Recalls
FN='out/ISOCommissionsRecalls.csv'
SQL='select tr."id", tr.mcaref, tr.effectivedate, tr.ammount, pr.lastname, pr.firstname, pr.fullname
from gfeny."transaction" tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype=20 and tr.status in (8,13)
and tr.userid=lgn.personid
and (5=any(lgn.roles) or 2=any(lgn.roles));'
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}


# Payments to Investors
FN='out/PaymentsToInvestors.csv'
SQL="select tr."id", tr.mcaref, tr.effectivedate, tr.ammount, pr.lastname, pr.firstname, pr.fullname
from gfeny."transaction" tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype=2 and tr.status in (8,13)
and tr.userid=lgn.personid
and 3=any(lgn.roles)
order by tr.mcaref, tr.effectivedate";
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

# Payments to Investors tot by mca
FN='out/PaymentsToInvestorsTotal.csv'
SQL="select SUM(tr.ammount) Amount, tr.mcaref, pr.lastname, pr.firstname, pr.fullname
from gfeny.transaction tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype=2 and tr.status in (8,13)
and tr.userid=lgn.personid
and 3=any(lgn.roles)
group by tr.mcaref, tr.userid, pr.lastname, pr.firstname, pr.fullname
order by tr.mcaref";
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

# Payments to Investors
FN='out/PaymentsToInvestorsTotal.csv'
SQL='select tr.mcaref, sum(tr.ammount), pr.fullname, pr.lastname, pr.firstname, pr.id
from gfeny."transaction" tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype=2 and tr.status in (8,13)
and tr.userid=lgn.personid
and 3=any(lgn.roles)
group by tr.mcaref, pr.id;'
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}


# Investment towards deals
FN='out/InvestmentsTowarsDeals.csv'
SQL='select tr."id", tr.mcaref, tr.effectivedate, tr.ammount, pr.lastname, pr.firstname, pr.fullname
from gfeny."transaction" tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype IN (5,6,7) and tr.status in (8,13)
and tr.userid=lgn.personid
and 3=any(lgn.roles)
order by tr.mcaref;'
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}


# Investment towards deals
FN='out/InvestmentsTowarsDealsTotals.csv'
SQL='select tr.mcaref, sum(tr.ammount), pr.fullname, pr.lastname, pr.firstname, pr.id
from gfeny."transaction" tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype IN (5,6,7) and tr.status in (8,13)
and tr.userid=lgn.personid
and 3=any(lgn.roles)
group by tr.mcaref, pr.id;'
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}

# Refunds to Investors
FN='out/InvestorsRefunds.csv'
SQL="select tr."id", tr.mcaref, tr.effectivedate, tr.ammount, pr.lastname, pr.firstname, pr.fullname
from gfeny."transaction" tr, gfeny.person pr, gfeny.login lgn
where tr.userid=pr.id and tr.transtype=9 and tr.status in (8,13)
and tr.userid=lgn.personid
and 3=any(lgn.roles)
order by tr.mcaref, tr.effectivedate";
echo ${SQL}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" > ${FN}