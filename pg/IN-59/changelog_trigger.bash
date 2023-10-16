#!/bin/bash

set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


pg_execute "
CREATE OR REPLACE FUNCTION trigger_changelog_transaction() RETURNS trigger AS \$$
DECLARE 
    old_json JSONB;
    new_json JSONB;
    username TEXT;
    uid INT;
BEGIN
    IF TG_OP = 'INSERT'
    THEN
        new_json := TO_JSONB(NEW);
        username := new_json->>'create_user';
    ELSIF TG_OP = 'UPDATE'
    THEN
        new_json := TO_JSONB(NEW);
        old_json := TO_JSONB(OLD);
        username := new_json->>'update_user';
    ELSIF TG_OP = 'DELETE'
    THEN
        old_json := TO_JSONB(OLD);
    END IF;

    IF username IS NOT NULL
    THEN
        SELECT personid INTO uid FROM %SCHEMA%.login WHERE userid=username LIMIT 1;
    END IF;

    IF TG_OP = 'INSERT'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val)
            VALUES (uid, TG_TABLE_NAME, NEW.id, TG_OP, new_json);

        RETURN NEW;
    ELSIF TG_OP = 'UPDATE'
    THEN
        SELECT JSONB_OBJECT_AGG(new_key, new_value), JSONB_OBJECT_AGG(old_key, old_value)
        INTO new_json, old_json
        FROM JSONB_EACH(new_json) AS n(new_key, new_value)
        JOIN JSONB_EACH(old_json) AS o(old_key, old_value)
        ON new_key=old_key AND new_value<>old_value AND new_key<>'update_timestamp';

        IF new_json IS NOT NULL OR old_json IS NOT NULL
        THEN
            INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val, old_val)
                VALUES (uid, TG_TABLE_NAME, NEW.id, TG_OP, new_json, old_json);
        END IF;

        RETURN NEW;
    ELSIF TG_OP = 'DELETE'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, old_val)
            VALUES (uid, TG_TABLE_NAME, OLD.id, TG_OP, old_json);
        RETURN OLD;
    END IF;

    RETURN COALESCE(NEW, OLD);

    EXCEPTION
    WHEN others THEN
        RAISE INFO 'Exception in trigger_changelog_transaction: %, state %', SQLERRM, SQLSTATE;
        RETURN COALESCE(NEW, OLD);
END;
\$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
"


pg_execute "
CREATE OR REPLACE FUNCTION trigger_changelog_person() RETURNS trigger AS \$$
DECLARE 
    old_json JSONB;
    new_json JSONB;
    uid INT;
BEGIN
    IF TG_OP = 'INSERT'
    THEN
        new_json := TO_JSONB(NEW);
        uid := new_json->>'update_user';
    ELSIF TG_OP = 'UPDATE'
    THEN
        new_json := TO_JSONB(NEW);
        old_json := TO_JSONB(OLD);
        uid := new_json->>'update_user';
    ELSIF TG_OP = 'DELETE'
    THEN
        old_json := TO_JSONB(OLD);
    END IF;

    IF TG_OP = 'INSERT'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val)
            VALUES (uid, TG_TABLE_NAME, NEW.id::BIGINT, TG_OP, new_json);

        RETURN NEW;
    ELSIF TG_OP = 'UPDATE'
    THEN
        SELECT JSONB_OBJECT_AGG(new_key, new_value), JSONB_OBJECT_AGG(old_key, old_value)
        INTO new_json, old_json
        FROM JSONB_EACH(new_json) AS n(new_key, new_value)
        JOIN JSONB_EACH(old_json) AS o(old_key, old_value)
        ON new_key=old_key AND new_value<>old_value AND new_key<>'update_user';

        IF new_json IS NOT NULL OR old_json IS NOT NULL
        THEN
            INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val, old_val)
                VALUES (uid, TG_TABLE_NAME, NEW.id::BIGINT, TG_OP, new_json, old_json);
        END IF;

        RETURN NEW;
    ELSIF TG_OP = 'DELETE'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, old_val)
            VALUES (uid, TG_TABLE_NAME, OLD.id::BIGINT, TG_OP, old_json);
        RETURN OLD;
    END IF;

    RETURN COALESCE(NEW, OLD);

    EXCEPTION
    WHEN others THEN
        RAISE INFO 'Exception in trigger_changelog_person: %, state %', SQLERRM, SQLSTATE;
        RETURN COALESCE(NEW, OLD);
END;
\$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
"


pg_execute "
CREATE OR REPLACE FUNCTION trigger_changelog_bankacount() RETURNS trigger AS \$$
DECLARE 
    old_json JSONB;
    new_json JSONB;
    uid INT;
BEGIN
    IF TG_OP = 'INSERT'
    THEN
        new_json := TO_JSONB(NEW);
        uid := new_json->>'update_user';
    ELSIF TG_OP = 'UPDATE'
    THEN
        new_json := TO_JSONB(NEW);
        old_json := TO_JSONB(OLD);
        uid := new_json->>'update_user';
    ELSIF TG_OP = 'DELETE'
    THEN
        old_json := TO_JSONB(OLD);
    END IF;

    IF TG_OP = 'INSERT'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val)
            VALUES (uid, TG_TABLE_NAME, NEW.id::BIGINT, TG_OP, new_json);

        RETURN NEW;
    ELSIF TG_OP = 'UPDATE'
    THEN
        SELECT JSONB_OBJECT_AGG(new_key, new_value), JSONB_OBJECT_AGG(old_key, old_value)
        INTO new_json, old_json
        FROM JSONB_EACH(new_json) AS n(new_key, new_value)
        JOIN JSONB_EACH(old_json) AS o(old_key, old_value)
        ON new_key=old_key AND new_value<>old_value AND new_key<>'update_user';

        IF new_json IS NOT NULL OR old_json IS NOT NULL
        THEN
            INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val, old_val)
                VALUES (uid, TG_TABLE_NAME, NEW.id::BIGINT, TG_OP, new_json, old_json);
        END IF;

        RETURN NEW;
    ELSIF TG_OP = 'DELETE'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, old_val)
            VALUES (uid, TG_TABLE_NAME, OLD.id::BIGINT, TG_OP, old_json);
        RETURN OLD;
    END IF;

    RETURN COALESCE(NEW, OLD);

    EXCEPTION
    WHEN others THEN
        RAISE INFO 'Exception in trigger_changelog_bankacount: %, state %', SQLERRM, SQLSTATE;
        RETURN COALESCE(NEW, OLD);
END;
\$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
"


pg_execute "
CREATE OR REPLACE FUNCTION trigger_changelog_userdefaults() RETURNS trigger AS \$$
DECLARE 
    old_json JSONB;
    new_json JSONB;
    uid INT;
BEGIN
    IF TG_OP = 'INSERT'
    THEN
        new_json := TO_JSONB(NEW);
        uid := new_json->>'update_user';
    ELSIF TG_OP = 'UPDATE'
    THEN
        new_json := TO_JSONB(NEW);
        old_json := TO_JSONB(OLD);
        uid := new_json->>'update_user';
    ELSIF TG_OP = 'DELETE'
    THEN
        old_json := TO_JSONB(OLD);
    END IF;

    IF TG_OP = 'INSERT'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val)
            VALUES (uid, TG_TABLE_NAME, NEW.userid::BIGINT, TG_OP, new_json);

        RETURN NEW;
    ELSIF TG_OP = 'UPDATE'
    THEN
        SELECT JSONB_OBJECT_AGG(new_key, new_value), JSONB_OBJECT_AGG(old_key, old_value)
        INTO new_json, old_json
        FROM JSONB_EACH(new_json) AS n(new_key, new_value)
        JOIN JSONB_EACH(old_json) AS o(old_key, old_value)
        ON new_key=old_key AND new_value<>old_value AND new_key<>'update_user';

        IF new_json IS NOT NULL OR old_json IS NOT NULL
        THEN
            INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, new_val, old_val)
                VALUES (uid, TG_TABLE_NAME, NEW.userid::BIGINT, TG_OP, new_json, old_json);
        END IF;

        RETURN NEW;
    ELSIF TG_OP = 'DELETE'
    THEN
        INSERT INTO %SCHEMA%.changelog(userid, table_name, recid, operation, old_val)
            VALUES (uid, TG_TABLE_NAME, OLD.userid::BIGINT, TG_OP, old_json);
        RETURN OLD;
    END IF;

    RETURN COALESCE(NEW, OLD);

    EXCEPTION
    WHEN others THEN
        RAISE INFO 'Exception in trigger_changelog_userdefaults: %, state %', SQLERRM, SQLSTATE;
        RETURN COALESCE(NEW, OLD);
END;
\$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
"

pg_execute 'DROP TRIGGER IF EXISTS trigger_change_transaction ON %SCHEMA%.transaction;'
pg_execute 'DROP FUNCTION IF EXISTS trigger_change_table_func;'
pg_execute 'CREATE TRIGGER trigger_change_transaction AFTER INSERT OR UPDATE OR DELETE ON %SCHEMA%.transaction FOR EACH ROW EXECUTE PROCEDURE trigger_changelog_transaction();'
pg_execute 'DROP TRIGGER IF EXISTS trigger_change_person ON %SCHEMA%.person;'
pg_execute 'CREATE TRIGGER trigger_change_person AFTER INSERT OR UPDATE OR DELETE ON %SCHEMA%.person FOR EACH ROW EXECUTE PROCEDURE trigger_changelog_person();'
pg_execute 'DROP TRIGGER IF EXISTS trigger_change_bankacount ON %SCHEMA%.bankacount;'
pg_execute 'CREATE TRIGGER trigger_change_bankacount AFTER INSERT OR UPDATE OR DELETE ON %SCHEMA%.bankacount FOR EACH ROW EXECUTE PROCEDURE trigger_changelog_bankacount();'
pg_execute 'DROP TRIGGER IF EXISTS trigger_change_userdefaults ON %SCHEMA%.userdefaults;'
pg_execute 'CREATE TRIGGER trigger_change_userdefaults AFTER INSERT OR UPDATE OR DELETE ON %SCHEMA%.userdefaults FOR EACH ROW EXECUTE PROCEDURE trigger_changelog_userdefaults();'
