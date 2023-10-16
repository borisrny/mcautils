#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



VENUE='UnitedFirst-BasePoint'
RESTAPI='https://client.achprocessing.com/RestAPI/api/ach'

DEBIT_NAME='APIdacaunited'
DEBIT_PWD='Apidacaunited2023'
DEBIT_KEY='986dace5-bae4-4770-8240-34ede10fcdf5'

CREDIT_NAME='APIdacaunited'
CREDIT_PWD='Apidacaunited2023'
CREDIT_KEY='986dace5-bae4-4770-8240-34ede10fcdf5'

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
