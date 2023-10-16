#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD='xxx'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'

VENUE='GFENY'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (1, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
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
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
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
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"



VENUE='SLC'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (2, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"da12cb11-e9a6-49b4-ae51-99c8a98b1fa7\",
        \"UserName\": \"APIfirststandartadmin\",
        \"Password\": \"Apifirst2020\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"e0a01882-4eeb-4ffd-a664-8a2d389da1f4\",
        \"UserName\": \"APIfirststandartadmincredits\",
        \"Password\": \"Apifirstcredits2020\"
		  }
	  }
}'
]::json[]
);
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"




VENUE='LENDORA'
TABLE='dealvenue'
INS_REC="INSERT INTO ${SCHEMA}.${TABLE} (code, description) VALUES ('${VENUE}', '${VENUE}');"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

TABLE='achvenue'
INS_REC="\
INSERT INTO ${SCHEMA}.${TABLE}(dealvenueid, code, description, targetconnoverride, achprocessors)
VALUES (3, '${VENUE}', '${VENUE}', 'apicredit', array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"4d1f3009-3a9a-42cf-9c52-31cf0a207c87\",
        \"UserName\": \"APIlendoraadmin\",
        \"Password\": \"Apilendora2020\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"0daf74ad-153d-4de3-877d-945af21aae42\",
        \"UserName\": \"APIlendorasd\",
        \"Password\": \"Apilendorasd2020\"
		  }
	  }
}'
]::json[]
);
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

