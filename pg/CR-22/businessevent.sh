#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"
TABLE="%SCHEMA%.businessevent"


pg_execute "drop table if exists ${TABLE}_back; "
pg_execute "create table ${TABLE}_back as (select * from $TABLE); "


pg_execute "UPDATE $TABLE b SET
subject_action=jsonb_set(subject_action::jsonb, '{from}', (select case when id=0 then 'null'::jsonb else id::text::jsonb end from mcastatus s where s.status=b.subject_action->>'from' or s.id=0 order by id desc limit 1))
WHERE b.subject_action->>'action'='Change Status'
AND b.subject_action->>'from' !~ '^\d+$';
"

pg_execute "UPDATE $TABLE b SET
subject_action=jsonb_set(subject_action::jsonb, '{to}', (select case when id=0 then 'null'::jsonb else id::text::jsonb end from mcastatus s where s.status=b.subject_action->>'to' or s.id=0 order by id desc limit 1))
WHERE b.subject_action->>'action'='Change Status'
AND b.subject_action->>'to' !~ '^\d+$';
"
