#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO public.mcadoccategory (category, description, roles) VALUES('Internal Payment History', 'Internal Payment History', (SELECT ARRAY_AGG(role_id) FROM ((SELECT UNNEST(roles) AS role_id FROM public.mcadoccategory WHERE category = 'Balance Letter / Contract') UNION (SELECT id AS role_id FROM userrole WHERE property_name = 'role_admin')) AS roles))"
