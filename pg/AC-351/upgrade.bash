#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'daily_fee_report',
  'Daily Fee Report',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['natallia@globalfundingexperts.com', 'maryna@globalfundingexperts.com', 'irina@globalfundingexperts.com', 'yelena@globalfundingexperts.com', 'steve@globalfundingexperts.com', 'boris@globalfundingexperts.com', 'sdf@qsf.capital', 'danny@globalfundingexperts.com', 'jan@yay.vc', 'jmayer@globalfundingexperts.com', 'bshaq@globalfundingexperts.com']
);
"
