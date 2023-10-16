#!/bin/bash

# users:
# commissions: 326

#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



RTR_FN=total_com-gfeny.csv
rm -f ${RTR_FN}
echo "id, mcaid, mcaref, effectivedate, ammount, venue, comment" > ${RTR_FN}

SQL="
select tr.id, tr.mcaid, tr.mcaref, tr.effectivedate, tr.ammount, tr.venue, tr.comment
from gfeny.transaction tr, gfeny.transcrosref cr
where tr.dealvenue=1
and tr.id=cr.transid
and tr.transtype=2 and tr.status in (8,13) and tr.userid=326
and tr.effectivedate >= '01/01/2021' and tr.effectivedate < '01/01/2022';
"
PGPASSWORD=${PASSWD} psql -AtF',' -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" >> ${RTR_FN}



RTR_FN=total_com-wr.csv
rm -f ${RTR_FN}
echo "id, mcaid, mcaref, effectivedate, ammount, venue, comment" > ${RTR_FN}

SQL="
select tr.id, tr.mcaid, tr.mcaref, tr.effectivedate, tr.ammount, tr.venue, tr.comment
from gfeny.transaction tr, gfeny.transcrosref cr
where tr.dealvenue=38
and tr.id=cr.transid
and tr.transtype=2 and tr.status in (8,13) and tr.userid=326
and tr.effectivedate >= '01/01/2021' and tr.effectivedate < '01/01/2022';
"
PGPASSWORD=${PASSWD} psql -AtF',' -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" >> ${RTR_FN}




#
#SQL="
#select tr.id, tr.mcaid, tr.mcaref, tr.effectivedate, tr.ammount, tr.venue, tr.comment
#from gfeny.transaction tr, gfeny.transcrosref cr, gfeny.transaction comtr
#where tr.dealvenue=38
#and tr.id=cr.transid and cr.refid=comtr.id and comtr.transtype=11
#and tr.transtype=2 and tr.status in (8,13) and tr.userid=326
#and tr.effectivedate >= '01/01/2021' and tr.effectivedate < '01/01/2022';
#"
#PGPASSWORD=${PASSWD} psql -AtF',' -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}" >> ${RTR_FN}