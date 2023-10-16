create TABLE public.loginstatus
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT loginstatus_pkey PRIMARY KEY (id)
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table public.loginstatus
    OWNER to mcamaster;



create TABLE public.userrelationship
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT userrelationship_pkey PRIMARY KEY (id)
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table public.userrelationship
    OWNER to mcamaster;

create TABLE public.userrole
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT userrole_pkey PRIMARY KEY (id)
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table public.userrole
    OWNER to mcamaster;
    
