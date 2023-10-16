#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO public.doccategory (category, description, doc_ref_type_id) SELECT 'AR Cover Letter', 'AR Cover Letter', (SELECT id FROM public.doc_ref_type WHERE name = 'mca') WHERE NOT EXISTS (SELECT id FROM public.doccategory WHERE category='AR Cover Letter')"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'ar_cover_letter',
  'AR Cover Letter',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['natallia@globalfundingexperts.com', 'maryna@globalfundingexperts.com', 'irina@globalfundingexperts.com', 'yelena@globalfundingexperts.com', 'steve@globalfundingexperts.com', 'boris@globalfundingexperts.com', 'sdf@qsf.capital', 'danny@globalfundingexperts.com', 'jan@yay.vc', 'jmayer@globalfundingexperts.com', 'bshaq@globalfundingexperts.com']
);
"
