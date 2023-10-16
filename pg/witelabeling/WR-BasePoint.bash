#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



VENUE='WhiteRoad-BasePoint'
RESTAPI='https://client.achprocessing.com/RestAPI/api/ach'

DEBIT_NAME='dacawhiteroad'
DEBIT_PWD='Dacawhiteroad2023'
DEBIT_KEY='add1c614-05da-4b9a-b2bd-3e86ce0896d0'

CREDIT_NAME='dacawhiteroad'
CREDIT_PWD='Dacawhiteroad2023'
CREDIT_KEY='add1c614-05da-4b9a-b2bd-3e86ce0896d0'

TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}') RETURNING id;"
VENUE_ID=(`PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -AXqtc "${INS_REC}"`)
echo $VENUE_ID

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (${VENUE_ID}, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${RESTAPI}\",
      \"header\": {
        \"ApiKey\" : \"${DEBIT_KEY}\",
        \"UserName\": \"${DEBIT_NAME}\",
        \"Password\": \"${DEBIT_PWD}\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"${RESTAPI}\",
      \"header\": {
        \"ApiKey\" : \"${CREDIT_KEY}\",
        \"UserName\": \"${CREDIT_NAME}\",
        \"Password\": \"${CREDIT_PWD}\"
		  }
	  }
}'
]::json[]
);
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"
echo ${INS_REC}
