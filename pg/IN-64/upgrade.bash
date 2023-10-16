#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "
CREATE OR REPLACE FUNCTION func_be_batch_id_default() RETURNS trigger AS \$$
DECLARE
BEGIN
  IF NEW.batch_id IS NULL OR NEW.batch_id = 0
  THEN
    NEW.batch_id = NEW.id;
  END IF;
  RETURN NEW;
END;
\$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
"
pg_execute "DROP TRIGGER IF EXISTS trig_be_batch_id_default ON %SCHEMA%.businessevent;"
pg_execute "CREATE TRIGGER trig_be_batch_id_default BEFORE INSERT ON %SCHEMA%.businessevent
FOR EACH ROW
EXECUTE FUNCTION func_be_batch_id_default();
"
