#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


pg_execute "
DROP TABLE IF EXISTS %SCHEMA%.docs;
DROP TABLE IF EXISTS public.doc_ref_type;
"

TABLE="doc_ref_type"
pg_execute "
CREATE TABLE IF NOT EXISTS public.${TABLE}
(
    id SERIAL NOT NULL PRIMARY KEY,
    name character varying NOT NULL
);"
pg_execute "INSERT INTO public.${TABLE} (name) VALUES ('mca');"
pg_execute "INSERT INTO public.${TABLE} (name) VALUES ('user');"
pg_execute "INSERT INTO public.${TABLE} (name) VALUES ('merchant');"



TABLE="docs"
pg_execute "
CREATE TABLE IF NOT EXISTS %SCHEMA%.${TABLE}
(
    id SERIAL NOT NULL PRIMARY KEY,
    ref_id integer NOT NULL,
    ref_type integer NOT NULL,
    create_userid integer NOT NULL,
    categoryid integer,
    create_timestamp timestamp with time zone NOT NULL,
    filename character varying NOT NULL,
    description character varying NOT NULL,
    is_temp BOOL NOT NULL DEFAULT false,

    CONSTRAINT categoryid_fk FOREIGN KEY (categoryid)
        REFERENCES public.mcadoccategory (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT ref_type_fk FOREIGN KEY (ref_type)
        REFERENCES public.doc_ref_type (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
"
pg_execute "
CREATE INDEX ${TABLE}_ref_rtype_idx
    ON %SCHEMA%.${TABLE} USING btree
    (ref_id, ref_type)
    TABLESPACE pg_default;
"
pg_execute "ALTER TABLE %SCHEMA%.${TABLE} OWNER to %OWNER%;"
