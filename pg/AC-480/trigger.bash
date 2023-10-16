#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute 'DROP TRIGGER IF EXISTS trigger_change_bankacount ON %SCHEMA%.bankacount'
pg_execute 'DROP TRIGGER IF EXISTS trigger_change_bankaccount ON %SCHEMA%.bankaccount'
pg_execute 'CREATE TRIGGER trigger_change_bankaccount AFTER INSERT OR UPDATE OR DELETE ON %SCHEMA%.bankaccount FOR EACH ROW EXECUTE PROCEDURE trigger_changelog_bankacount();'
