#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD='xv7ob44qoQAh3wtWTPqpM=jB'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'





VENUE='BasePoint-FA'
RESTAPI='https://client.achprocessing.com/RestAPI/api/ach'

DEBIT_NAME='APIUF-BP01adminF'
DEBIT_PWD='Apiufadminf2023'
DEBIT_KEY='60909e70-0a0f-4a7b-9f34-0a4316ac4ca6'

CREDIT_NAME='APIUF-BP01creditsF'
CREDIT_PWD='Apiufcreditsf2023'
CREDIT_KEY='eab27c11-25f6-4bd5-95c3-6dded8e7bace'

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
