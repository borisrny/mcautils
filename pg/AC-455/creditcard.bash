#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "CREATE TABLE IF NOT EXISTS %SCHEMA%.creditcard (
    id SERIAL PRIMARY KEY,
    name character varying NOT NULL,
    type character varying NOT NULL,
    account character varying NOT NULL,
    expiry_date date NOT NULL,
    security_code int,
    zip_code character varying,
    ref_type INT NOT NULL,
    ref_id INT NOT NULL,
    is_active boolean NOT NULL,
    is_default boolean NOT NULL,
    update_user INT
)"

pg_execute "CREATE UNIQUE INDEX IF NOT EXISTS creditcard_ref_type_ref_id_is_default_key ON %SCHEMA%.creditcard (ref_type, ref_id, is_default) WHERE (is_default=true)"
