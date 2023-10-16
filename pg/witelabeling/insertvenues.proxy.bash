#!/bin/bash

# Local
USER='postgres'
PASSWD=''
DB='user2pg'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'

APIURL='http://52.34.56.53:5000/RestAPI/api/ach'


VENUE='GFENY-PROXY'
TABLE='dealvenue'
#INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (6, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"http://52.34.56.53:5000/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"6302d128-8e2d-4f29-8c6d-8fc0d485220b\",
        \"UserName\": \"APIgfeadmin\",
        \"Password\": \"Gfeadmin2018\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"http://52.34.56.53:5000/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"718f5d08-f7ea-430a-8295-60d360183a64\",
        \"UserName\": \"GFENYcredits\",
        \"Password\": \"Credits2019\"
		  }
	  }
}'
]::json[]
);
"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


VENUE='GFENY-BE2121-PROXY'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (8, '${VENUE}', '${VENUE}', 'apicredit', array['\
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
]::json[] WHERE id=11;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

