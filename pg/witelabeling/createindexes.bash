#!/bin/bash

# Local
USER='postgres'
PASSWD='xxx'
DB='user2pg'
HOST='localhost'
SCHEMA='gfeny'
OWNER='postgres'

#UAT2
USER='mcamaster'
PASSWD='xxx'
DB='gfeusermigrate'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='gfedevel'

#GFENY
USER='mcamaster'
PASSWD='xxx'
DB='postgres'
HOST='mca1-1-instance-1.cxrgcmhggkds.us-west-2.rds.amazonaws.com'
SCHEMA='gfeny'
OWNER='mcamaster'

TABLE='mcacommisionuser'
IDX_NMAE='com_user_mca_idx'
DEF='(mcaid ASC NULLS LAST)'
echo ${TABLE} ${IDX_NMAE} ${DEF}
IDX_SQL="CREATE INDEX ${IDX_NMAE} ON ${SCHEMA}.${TABLE} USING btree ${DEF}TABLESPACE pg_default;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${IDX_SQL}"

TABLE='mcaeml'
IDX_NMAE='com_user_offer_mca_idx'
DEF='(mcaid ASC NULLS LAST)'
echo ${TABLE} ${IDX_NMAE} ${DEF}
IDX_SQL="CREATE INDEX ${IDX_NMAE} ON ${SCHEMA}.${TABLE} USING btree ${DEF}TABLESPACE pg_default;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${IDX_SQL}"

TABLE='mcacontract'
IDX_NMAE='com_user_mcacontract_mca_idx'
DEF='(mcaid ASC NULLS LAST)'
echo ${TABLE} ${IDX_NMAE} ${DEF}
IDX_SQL="CREATE INDEX ${IDX_NMAE} ON ${SCHEMA}.${TABLE} USING btree ${DEF}TABLESPACE pg_default;"
PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${IDX_SQL}"
