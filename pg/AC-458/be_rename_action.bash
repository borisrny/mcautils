#!/bin/bash

PG_ENV="$1"
set -e
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_PATH/../pg_util.bash"

echo "1 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'note') WHERE subject_action->>'action'='note' "

echo "2 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'approve') WHERE subject_action->>'action'='approve' "

echo "3 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'approve', 'result', 'accept') WHERE subject_action->>'action'='Accept Approval' "

echo "4 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'approve', 'result', 'reject') WHERE subject_action->>'action'='Reject Approval' "

echo "5 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'decline') WHERE subject_action->>'action'='decline' "

echo "6 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'decline', 'result', 'accept') WHERE subject_action->>'action'='Accept Decline' "

echo "7 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'decline', 'result', 'reject') WHERE subject_action->>'action'='Reject Decline' "

echo "8 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'modify') WHERE subject_action->>'action'='modify' "

echo "9 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'modify', 'result', 'accept') WHERE subject_action->>'action'='Accept Modify' "

echo "10 of 10"
pg_execute "UPDATE %SCHEMA%.businessevent SET
subject_action=to_jsonb(subject_action) || jsonb_build_object('action', 'Increment Approval', 'request', 'modify', 'result', 'reject') WHERE subject_action->>'action'='Reject Modify' "
