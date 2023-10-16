#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="public.businesseventtype"
pg_execute "DROP TABLE IF EXISTS ${TABLE};
CREATE TABLE ${TABLE}
(
  id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
  type character varying,
  property_name character varying,
  value integer
)
with ( OIDS = FALSE ) TABLESPACE pg_default;
alter table ${TABLE} OWNER to %OWNER%;
INSERT INTO ${TABLE} (type, property_name, value) VALUES('action', 'assign', 1);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('action', 'complete', 2);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('action', 'unassign', 3);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('action', 'inprogress', 4);

INSERT INTO ${TABLE} (type, property_name, value) VALUES('subject', 'mca', 1);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('subject', 'transaction', 2);

INSERT INTO ${TABLE} (type, property_name, value) VALUES('assignee', 'user', 1);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('assignee', 'role', 2);

INSERT INTO ${TABLE} (type, property_name, value) VALUES('payment', 'samedayach', 1);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('payment', 'nextdayach', 2);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('payment', 'samedaywire', 3);

INSERT INTO ${TABLE} (type, property_name, value) VALUES('schedule', 'withoutshifting', 1);
INSERT INTO ${TABLE} (type, property_name, value) VALUES('schedule', 'shiftremaining', 2);
"

pg_execute "DROP TABLE IF EXISTS public.businesseventaction"
pg_execute "DROP TABLE IF EXISTS public.businesseventassigneetype"
pg_execute "DROP TABLE IF EXISTS public.businesseventsubjecttype"
