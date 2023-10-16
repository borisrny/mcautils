#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE="mcadoc"


pg_execute "
CREATE TABLE IF NOT EXISTS %SCHEMA%.${TABLE}
(
    id SERIAL NOT NULL PRIMARY KEY,
    mcaid integer NOT NULL,
    create_userid integer NOT NULL,
    categoryid integer,
    create_timestamp timestamp with time zone NOT NULL,
    filename character varying NOT NULL,
    description character varying NOT NULL,
    CONSTRAINT categoryid_fk FOREIGN KEY (categoryid)
        REFERENCES public.mcadoccategory (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;
"

pg_execute "
-- Index: ${TABLE}_mcaid_idx

-- DROP INDEX %SCHEMA%.${TABLE}_mcaid_idx;

CREATE INDEX ${TABLE}_mcaid_idx
    ON %SCHEMA%.${TABLE} USING btree
    (mcaid ASC NULLS LAST)
    TABLESPACE pg_default;
"

pg_execute "ALTER TABLE %SCHEMA%.${TABLE} OWNER to %OWNER%;"
