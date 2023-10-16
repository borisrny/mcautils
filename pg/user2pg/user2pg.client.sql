create TABLE gfeny.mcacommisionuser
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    mcaid integer NOT NULL,
    userid integer NOT NULL,
    baseindicator integer NOT NULL DEFAULT 1,
    commisionpct double precision NOT NULL,
    commisionamt double precision NOT NULL,
    paystrategy integer NOT NULL DEFAULT 1,
    firstpct double precision DEFAULT 50,
    setindex integer NOT NULL DEFAULT 0,
    active boolean NOT NULL DEFAULT false,
    CONSTRAINT mcacommisionuser_pkey PRIMARY KEY (id)
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.mcacommisionuser
    OWNER to mcamaster;

COMMENT ON COLUMN gfeny.mcacommisionuser.firstpct
    IS 'for first/last strategy, percent to pay on first increment';

COMMENT ON COLUMN gfeny.mcacommisionuser.setindex
    IS 'grouping of users for the mcaid.
0 - current selection
1,2,3 etc for inactive groups.';



create TABLE gfeny.person
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    firstname character varying COLLATE pg_catalog."default",
    lastname character varying COLLATE pg_catalog."default",
    fullname character varying COLLATE pg_catalog."default",
    emails character varying[] COLLATE pg_catalog."default",
    bankrecs integer[],
    cellphone character varying COLLATE pg_catalog."default",
    workphone character varying COLLATE pg_catalog."default",
    workphoneext character varying COLLATE pg_catalog."default",
    ssn character varying COLLATE pg_catalog."default",
    drivlic character varying COLLATE pg_catalog."default",
    dob date,
    address json,
    CONSTRAINT person_pkey PRIMARY KEY (id)
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.person
    OWNER to mcamaster;


create TABLE gfeny.userrelation
(
    userid integer,
    relatedid integer,
    type integer DEFAULT 1,
    CONSTRAINT userreltype_fk FOREIGN KEY (type)
        REFERENCES public.userrelationship (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
        NOT VALID
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.userrelation
    OWNER to mcamaster;
-- Index: idx_user_rel

-- DROP INDEX gfeny.idx_user_rel;

create UNIQUE INDEX idx_user_rel
    ON gfeny.userrelation USING btree
    (userid ASC NULLS LAST, relatedid ASC NULLS LAST, type ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: userrelation_userid_idx

-- DROP INDEX gfeny.userrelation_userid_idx;

create INDEX userrelation_userid_idx
    ON gfeny.userrelation USING btree
    (userid ASC NULLS LAST)
    TABLESPACE pg_default;


create TABLE gfeny.userdefaults
(
    displaydba boolean,
    mcacommissions double precision,
    conscommissions double precision,
    upfrontfee double precision,
    rtrfee double precision,
    comissionstrategy integer,
    withdrawalday integer,
    defparticipation double precision,
    interninvestacct boolean,
    userid integer NOT NULL,
    depositstrategy character varying COLLATE pg_catalog."default",
    CONSTRAINT userid_fk FOREIGN KEY (userid)
        REFERENCES gfeny.person (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.userdefaults
    OWNER to mcamaster;
-- Index: fki_userid_fk

-- DROP INDEX gfeny.fki_userid_fk;

create INDEX fki_userid_fk
    ON gfeny.userdefaults USING btree
    (userid ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_userdefaults_id

-- DROP INDEX gfeny.idx_userdefaults_id;

create UNIQUE INDEX idx_userdefaults_id
    ON gfeny.userdefaults USING btree
    (userid ASC NULLS LAST)
    TABLESPACE pg_default;




create TABLE gfeny.login
(
    personid integer NOT NULL,
    lastlogin timestamp without time zone,
    pwdexpiry timestamp with time zone,
    roles integer[],
    userid character varying COLLATE pg_catalog."default",
    status integer,
    confirmedon timestamp with time zone,
    usetfa boolean DEFAULT false,
    CONSTRAINT login_person_fk FOREIGN KEY (personid)
        REFERENCES gfeny.person (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
        NOT VALID,
    CONSTRAINT login_status_fk FOREIGN KEY (status)
        REFERENCES public.loginstatus (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
        NOT VALID
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.login
    OWNER to mcamaster;
-- Index: login_userid_idx

-- DROP INDEX gfeny.login_userid_idx;

create UNIQUE INDEX login_userid_idx
    ON gfeny.login USING btree
    (personid ASC NULLS LAST)
    TABLESPACE pg_default;


create TABLE gfeny.bankacount
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    account character varying COLLATE pg_catalog."default",
    routing character varying COLLATE pg_catalog."default",
    type integer DEFAULT 1,
    name character varying COLLATE pg_catalog."default",
    contact character varying COLLATE pg_catalog."default",
    phone character varying COLLATE pg_catalog."default",
    address json,
    CONSTRAINT bankacount_pkey PRIMARY KEY (id),
    CONSTRAINT bankaccount_type_fk FOREIGN KEY (type)
        REFERENCES public.accounttype (id) MATCH SIMPLE
        ON update NO ACTION
        ON delete NO ACTION
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.bankacount
    OWNER to mcamaster;


create TABLE gfeny.mcaeml
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    mcaid integer NOT NULL,
    userid integer NOT NULL,
    fa double precision NOT NULL DEFAULT 0,
    rate double precision NOT NULL DEFAULT 0,
    commission double precision NOT NULL,
    term double precision NOT NULL DEFAULT 0,
    payment double precision NOT NULL DEFAULT 0,
    createdate date NOT NULL DEFAULT CURRENT_DATE,
    createuser integer NOT NULL,
    setindex integer NOT NULL,
    agroup integer,
    CONSTRAINT mcaeml_pkey PRIMARY KEY (id)
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.mcaeml
    OWNER to mcamaster;


create TABLE gfeny.mcacontract
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    mcaid integer NOT NULL,
    createtime timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    createuser integer NOT NULL,
    filename character varying COLLATE pg_catalog."default",
    setindex integer NOT NULL,
    CONSTRAINT mcacontract_pkey PRIMARY KEY (id)
)
with (
    OIDS = FALSE
)
TABLESPACE pg_default;

alter table gfeny.mcacontract
    OWNER to mcamaster;

