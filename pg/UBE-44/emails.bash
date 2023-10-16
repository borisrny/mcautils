#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
SELECT
  'offer_has_exclusive',
  'Offer Has Exclusive',
  'accounting@xxxxxxx.com',
  'accounting@xxxxxxx.com',
  ARRAY['finaluw@xxxxxxx.com']
WHERE NOT EXISTS (SELECT 1 FROM emlconfig WHERE tag='offer_has_exclusive');
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
SELECT
  'external_document_completed',
  'External Document is Completed',
  'accounting@xxxxxxx.com',
  'accounting@xxxxxxx.com',
  ARRAY['finaluw@xxxxxxx.com']
WHERE NOT EXISTS (SELECT 1 FROM emlconfig WHERE tag='external_document_completed');
"
