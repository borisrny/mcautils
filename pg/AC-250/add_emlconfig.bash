#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'funded_report',
  'Funded report',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['maryna@globalfundingexperts.com', 'contracts@globalfundingexperts.com', 'bshaq@globalfundingexperts.com', 'alex1989@globalfundingexperts.com', 'boris@globalfundingexperts.com', 'steve@globalfundingexperts.com', 'alex@globalfundingexperts.com', 'samin@globalfundingexperts.com', 'angira@globalfundingexperts.com', 'olya@globalfundingexperts.com', 'pelin@globalfundingexperts.com', 'natallia@globalfundingexperts.com', 'danny@globalfundingexperts.com', 'alla@globalfundingexperts.com', 'jan@yay.vc,sdf@qsf.capital', 'kamila@globalfundingexperts.com', 'tg@qsf.capital', 'yelena@globalfundingexperts.com']
);
"
