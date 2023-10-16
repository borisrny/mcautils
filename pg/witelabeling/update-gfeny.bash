#!/bin/bash

#GFENY
USER='mcamaster'
PASSWD='xxx'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'
TABLE='achvenue'

RESTAPI="https://client.achprocessing.com/RestAPI/api/ach"

#GFE
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"ddc2ce16-5fe2-4a53-9b6c-92c4aa6c1b49\",
        \"UserName\": \"APIdsyadmin\",
        \"Password\": \"Apidsyadmin2023\"
		  }
	  }
}',
'{
\"name\": \"apicredit\",
\"value\": {
      \"url_base\": \"https://client.achprocessing.com/RestAPI/api/ach\",
      \"header\": {
        \"ApiKey\" : \"74099b7b-e7bb-4fdb-bb92-aab448e62582\",
        \"UserName\": \"APIdsycredits\",
        \"Password\": \"Apidsycredits2023\"
		  }
	  }
}'
]::json[] where id=1;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

#SLC
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] where id=2;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

#LENDORA
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] where id=4;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


#RADIUM2
DEBIT_NAME='APIradium2admin'
DEBIT_PWD='Apiradium2admin2020'
DEBIT_KEY='cc13f31d-69cd-4728-b001-a569f4809c23'

CREDIT_NAME='APIradium2credits'
CREDIT_PWD='Apiradium2credits2020'
CREDIT_KEY='58a4c30b-2c6d-479c-bc5b-9ed990fb83ca'
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] where id=35;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


#GFENY-BE2121
INS_REC="\
UPDATE ${SCHEMA}.${TABLE} SET achprocessors=array['\
{
\"name\": \"apidebit\",
\"value\": {
      \"url_base\": \"${RESTAPI}\",
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


#Lacent
DEBIT_NAME='APIlacentadmin'
DEBIT_PWD='Apilacentadmin2021'
DEBIT_KEY='cfa30756-0f06-4038-959e-7af80003725d'

CREDIT_NAME='APIlacentcredits'
CREDIT_PWD='Apilacentcredits2021'
CREDIT_KEY='883f2a98-688f-431a-8254-1dbe30f6e9b1'
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] WHERE id=37;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

#WhiteRoad
DEBIT_NAME='APIwhiteroadadmin'
DEBIT_PWD='Apiwhiteroadadmin2021'
DEBIT_KEY='f798ab6e-b809-4016-8051-138ef6f0f554'

CREDIT_NAME='APIwhiteroadcredits'
CREDIT_PWD='Apiwhitecredits2021'
CREDIT_KEY='296a111b-2d2d-4f3d-87ce-0ea032b9a20f'
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] WHERE id=38;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


#WhiteRoadSub
DEBIT_NAME='APIwhiteroadsub'
DEBIT_PWD='Apiwhiteroadsub2021'
DEBIT_KEY='bdee4ad7-9cdf-42c9-a62d-c844d3bdc5bd'

CREDIT_NAME='APIwhiteroadsubcredits'
CREDIT_PWD='Apiwhiteroadcredits2021'
CREDIT_KEY='9a9ea628-7884-4bcd-9544-f86ed440cf9c'
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] WHERE id=67;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"

#WhiteRoadSubPointFin
DEBIT_NAME='APIdacaadmin'
DEBIT_PWD='Apidacaadmin2022'
DEBIT_KEY='80827074-c012-4f70-aed9-5cd3110387ec'

CREDIT_NAME='APIdacaadmin'
CREDIT_PWD='Apidacaadmin2022'
CREDIT_KEY='80827074-c012-4f70-aed9-5cd3110387ec'
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] WHERE id=100;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


#EHC
DEBIT_NAME='APIhudsonoperationsadmin'
DEBIT_PWD='Apihudsonoperations2023'
DEBIT_KEY='5963d84c-0223-4674-b2e5-337c14f219f1'

CREDIT_NAME='APIhudsonoperationscredits'
CREDIT_PWD='Apihudsonoperationscredits2023'
CREDIT_KEY='4d38d70a-fe41-4798-8f7f-506e9dbd4908'
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] WHERE id=133;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"


#GFENY-OLD
INS_REC="\
update ${SCHEMA}.${TABLE} set achprocessors=array['\
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
]::json[] WHERE id=166;
"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${INS_REC}"
