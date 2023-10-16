#!/bin/bash

USER='postgres'
PASSWD='Kikiriki1317!'
DB='postgres'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'



VENUE='APITest'
RESTAPI='https://test.achprocessing.com/finanyzlrapi/api/ach'

DEBIT_NAME='MCAGFEtest'
DEBIT_PWD='k$R51TF4I@Lb^4RVL'
DEBIT_KEY='e1f4cf96-9517-43f3-bba7-5eff9ce93b8e'

CREDIT_NAME='MCAGFEtest'
CREDIT_PWD='k$R51TF4I@Lb^4RVL'
CREDIT_KEY='e1f4cf96-9517-43f3-bba7-5eff9ce93b8e'
VENUE_ID=16


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


