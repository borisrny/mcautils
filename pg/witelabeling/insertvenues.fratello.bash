#!/bin/bash

##
USER='mcamaster'
PASSWD='UeQhVG8TAER6H7Ks'
DB='postgres'
HOST='database-1.cxtnh3g0kl2l.us-east-1.rds.amazonaws.com'
SCHEMA='fratello'
OWNER='mcamaster'

VENUE='FRATELLO'
#TABLE='dealvenue'
#INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (1, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"8b6e2a23-64ef-48ec-a207-337daff7a7d0\",
        \"UserName\": \"APIfratelloadmin\",
        \"Password\": \"Apifratelloadmin2022\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"efec693f-c51e-4a35-bae6-c89266e7f277\",
        \"UserName\": \"APIfratellocredits\",
        \"Password\": \"Apifratellocredits2022!\"
		  }
	  }
}'
]::json[]
);
"
#PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

SQL="
update ${SCHEMA}.${TABLE} set achprocessors=
array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"8b6e2a23-64ef-48ec-a207-337daff7a7d0\",
        \"UserName\": \"APIfratelloadmin\",
        \"Password\": \"Apifratelloadmin2022\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"efec693f-c51e-4a35-bae6-c89266e7f277\",
        \"UserName\": \"APIfratellocredits\",
        \"Password\": \"Apifratellocredits2022!\"
		  }
	  }
}'
]::json[]
where id=1
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"
