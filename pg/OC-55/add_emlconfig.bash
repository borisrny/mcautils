#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'collection_report_payment',
  'Collection report payment',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['rep5@globalfundingexperts.com', 'alex1989@globalfundingexperts.com', 'bshaq@globalfundingexperts.com', 'boris@globalfundingexperts.com', 'steve@globalfundingexperts.com', 'accountrep@globalfundingexperts.com', 'rep2@globalfundingexperts.com', 'rep3@globalfundingexperts.com', 'rep4@globalfundingexperts.com', 'rep@globalfundingexperts.com', 'maryna@globalfundingexperts.com', 'natallia@globalfundingexperts.com', 'yelena@globalfundingexperts.com', 'robert@globalfundingexperts.com']
);
"
