#!/bin/bash


#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



FN=RTR-BALANCE-GFE.csv
rm -f ${FN}
echo "mcaid,RTR,RECIEVED,RTR-BALANCE,RTR-B-35" > ${FN}

SQL="
with tomerchant as (
select trsent.mcaid, SUM(trsent.ammount) sent
from gfeny.transaction trsent
where trsent.status in (8,13) and trsent.transtype in (5,6,7,16)
and trsent.effectivedate < '01/01/2022'
and trsent.dealvenue=1
and trsent.mcaid>0
group by trsent.mcaid
),
payments as (
select trsent.mcaid, SUM(trsent.ammount) received
from gfeny.transaction trsent
where trsent.status in (8,13) and trsent.transtype in (2,17,49)
and trsent.effectivedate < '01/01/2021'
and trsent.dealvenue=1
and trsent.mcaid>0
group by trsent.mcaid
)
select ps.mcaid, ps.rate*m.sent rtr, COALESCE(pm.received, 0),
ps.rate*m.sent-COALESCE(pm.received, 0) as rtr_balance,
(ps.rate*m.sent-COALESCE(pm.received, 0))*(1-0.035) as rtr_balance_35
from gfeny.portfoliosnap ps, tomerchant m
left join payments as pm on (pm.mcaid=m.mcaid)
where ps.mcaid=m.mcaid
"
PGPASSWORD=${PASSWD} psql -AtF',' -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" >> ${FN}


SQL="
select inv.mcaid, inv.userid, inv.part_pct, p.firstname, p.lastname
from gfeny.mcainvestors inv, gfeny.person p
where inv.status=1 and inv.userid=p.id
order by inv.mcaid
"
FN=INVESTORS.csv
rm -f ${FN}
echo "mcaid,userid,part,firstname,lastname" > ${FN}
PGPASSWORD=${PASSWD} psql -AtF',' -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" >> ${FN}
