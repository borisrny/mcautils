#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO public.doccategory (category, description, doc_ref_type_id) SELECT 'Banana Report', 'Banana Report', (SELECT id FROM public.doc_ref_type WHERE name='pm') WHERE NOT EXISTS (SELECT id FROM public.doccategory WHERE category='Banana Report')"
