#!/bin/bash

USER='postgres'
DB='user2pg'
HOST='localhost'

F1='roles.csv'
T1='public.userrole'
F2='loginstatus.csv'
T2='public.loginstatus'
T3='public.userrelationship'

psql -h ${HOST} -U ${USER} -d ${DB} -c "\copy ${T1} FROM '${F1}' delimiter ',' CSV HEADER;"
psql -h ${HOST} -U ${USER} -d ${DB} -c "\copy ${T2} FROM '${F2}' delimiter ',' CSV HEADER;"
#psql -h ${HOST} -U ${USER} -d ${DB} -c "INSERT INTO ${T3} (name) VALUES ('iso-isorel')"