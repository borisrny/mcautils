#!/bin/bash

# Local
USER='postgres'
PASSWD='xxxxxx'
DB='user2pg'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'


VENUE='RADIUM2'
RESTAPI='https://client.achprocessing.com/RestAPI/api/ach'

DEBIT_NAME='APIradium2admin'
DEBIT_PWD='Apiradium2admin2020'
DEBIT_KEY='cc13f31d-69cd-4728-b001-a569f4809c23'

CREDIT_NAME='APIradium2credits'
CREDIT_PWD='Apiradium2credits2020'
CREDIT_KEY='58a4c30b-2c6d-479c-bc5b-9ed990fb83ca'
VENUE_ID=35

TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}') RETURNING id;"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


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


