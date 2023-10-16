#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

TABLE_PERMS="permission"
TABLE_ROLES_PERMS="userroles_permissions"

pg_execute "DROP TABLE IF EXISTS ${TABLE_ROLES_PERMS};"
pg_execute "DROP TABLE IF EXISTS ${TABLE_PERMS};"

pg_execute "
CREATE TABLE IF NOT EXISTS ${TABLE_PERMS}
(
    id SERIAL NOT NULL PRIMARY KEY,
    permission character varying NOT NULL,
    description character varying NOT NULL,
    CONSTRAINT permission_unique UNIQUE (permission)
)

TABLESPACE pg_default;
"
pg_execute "ALTER TABLE ${TABLE_PERMS} OWNER to %OWNER%;"


pg_execute "
CREATE TABLE IF NOT EXISTS ${TABLE_ROLES_PERMS}
(
    id SERIAL NOT NULL PRIMARY KEY,
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    CONSTRAINT fk_role_id FOREIGN KEY(role_id) REFERENCES userrole(id),
    CONSTRAINT fk_permission_id FOREIGN KEY(permission_id) REFERENCES permission(id)
)

TABLESPACE pg_default;
"
pg_execute "ALTER TABLE ${TABLE_ROLES_PERMS} OWNER to %OWNER%;"
