#!/bin/bash

# Local
USER='postgres'
PASSWD='xxx!'
DB='user2pg'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'
APIURL='http://localhost:5000'

#Prod
USER='mcamaster'
PASSWD=''
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'
APIURL='https://client.achprocessing.com/RestAPI/api/ach'



VENUE='GFENY-BE2121'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (36, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${APIURL}\",
      \"header\": {
        \"ApiKey\" : \"47d04444-9c1c-4616-a664-158bacdc8cfe\",
        \"UserName\": \"APIgfeny\",
        \"Password\": \"Apigfeny2021\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"${APIURL}\",
      \"header\": {
        \"ApiKey\" : \"47d04444-9c1c-4616-a664-158bacdc8cfe\",
        \"UserName\": \"APIgfeny\",
        \"Password\": \"Apigfeny2021\"
		  }
	  }
}'
]::json[]
);
"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


TABLE='achvenue'
INS_REC="\
UPDATE ${SCHEMA}.${TABLE} SET achprocessors=array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${APIURL}\",
      \"header\": {
        \"ApiKey\" : \"47d04444-9c1c-4616-a664-158bacdc8cfe\",
        \"UserName\": \"APIgfeny\",
        \"Password\": \"Apigfeny2021\"
		  }
	  }
}'
]::json[] WHERE id=36;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

