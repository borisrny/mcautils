#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD='xv7ob44qoQAh3wtWTPqpM=jB'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



VENUE='WhiteRoadSub'
RESTAPI='https://client.achprocessing.com/RestAPI/api/ach'

DEBIT_NAME='APIwhiteroadsub'
DEBIT_PWD='Apiwhiteroadsub2021'
DEBIT_KEY='bdee4ad7-9cdf-42c9-a62d-c844d3bdc5bd'

CREDIT_NAME='APIwhiteroadsubcredits'
CREDIT_PWD='Apiwhiteroadcredits2021'
CREDIT_KEY='9a9ea628-7884-4bcd-9544-f86ed440cf9c'
VENUE_ID=67

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
echo ${INS_REC}

UPD_REC="\
UPDATE ${SCHEMA}.${TABLE} SET achprocessors=array['\
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
]::json[] WHERE id=${VENUE_ID};
"
echo ${UPD_REC}
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${UPD_REC}"
