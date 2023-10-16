#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'



VENUE='EHC'
RESTAPI='https://client.achprocessing.com/RestAPI/api/ach'

DEBIT_NAME='APIhudsonoperationsadmin'
DEBIT_PWD='Apihudsonoperations2023'
DEBIT_KEY='5963d84c-0223-4674-b2e5-337c14f219f1'

CREDIT_NAME='APIhudsonoperationscredits'
CREDIT_PWD='Apihudsonoperationscredits2023'
CREDIT_KEY='4d38d70a-fe41-4798-8f7f-506e9dbd4908'
VENUE_ID=133

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
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"
#echo ${INS_REC}


SQL="
update ${SCHEMA}.${TABLE} set achprocessors=
array['\
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
where id=${VENUE_ID}
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"
#echo ${SQL}
