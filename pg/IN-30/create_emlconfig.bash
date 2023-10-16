#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "DROP TABLE IF EXISTS emlconfig"

pg_execute "CREATE TABLE emlconfig (
  tag varchar(100) PRIMARY KEY,
  name varchar(255) NOT NULL,
  venue varchar(20) not null default 'boto3',
  sender varchar(255) not null default 'rep@globalfundingexperts.com',
  reply_to varchar(255),
  to_address text[],
  cc text[],
  bcc text[]
);"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'dba_returned_payments',
  'DBA Returned Payments',
  'rep@globalfundingexperts.com',
  'rep@globalfundingexperts.com',
  ARRAY['accountrep@globalfundingexperts.com', 'rep@globalfundingexperts.com', 'rep2@globalfundingexperts.com', 'rep3@globalfundingexperts.com', 'rep4@globalfundingexperts.com', 'rep5@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'underwriter_approval_process_validation',
  'Underwriter approval process validation',
  'rep@globalfundingexperts.com',
  'rep@globalfundingexperts.com',
  ARRAY['angira@globalfundingexperts.com', 'kamila@globalfundingexperts.com', 'samin@globalfundingexperts.com', 'bshaq@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'accounting_approval_process_validation',
  'Accounting approval process validation',
  'rep@globalfundingexperts.com',
  'rep@globalfundingexperts.com',
  ARRAY['yelena@globalfundingexperts.com', 'maryna@globalfundingexperts.com', 'natallia@globalfundingexperts.com', 'bshaq@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'iso_renewal_notification',
  'ISO renewal notification',
  'rep@globalfundingexperts.com',
  'rep@globalfundingexperts.com',
  ARRAY['bshaq@globalfundingexperts.com', 'boris@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'application_declined',
  'Application declined',
  'underwriting@globalfundingexperts.com',
  'underwriting@globalfundingexperts.com',
  ARRAY['underwriting@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'application_approved',
  'Application approved',
  'underwriting@globalfundingexperts.com',
  'underwriting@globalfundingexperts.com',
  ARRAY['underwriting@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'comm_deal_funded',
  'Comm deal funded',
  'underwriting@globalfundingexperts.com',
  'underwriting@globalfundingexperts.com',
  ARRAY['underwriting@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'ach_comm_created',
  'ACH comm created',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['accounting@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'ach_debit_created',
  'ACH debit created',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['accounting@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc)
VALUES(
  'transaction_activated',
  'Transaction activated',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['accounting@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, cc, to_address)
VALUES(
  'returned_transactions',
  'Returned transactions',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['accounting@globalfundingexperts.com'],
  ARRAY['steve@globalfundingexperts.com', 'bshaq@globalfundingexperts.com', 'alex1989@globalfundingexperts.com', 'accountrep@globalfundingexperts.com', 'contracts@globalfundingexperts.com', 'kamila@globalfundingexperts.com', 'pelin@globalfundingexperts.com', 'rep@globalfundingexperts.com', 'rep2@globalfundingexperts.com', 'rep3@globalfundingexperts.com', 'samin@globalfundingexperts.com', 'olya@globalfundingexperts.com', 'angira@globalfundingexperts.com', 'yelena@globalfundingexperts.com', 'maryna@globalfundingexperts.com', 'natallia@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'payment_status_change',
  'Payment status change',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['yelena@globalfundingexperts.com', 'bshaq@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address, cc)
VALUES(
  'returned_deposits_withdrawals',
  'Returned deposits withdrawals',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['accounting@globalfundingexperts.com'],
  ARRAY['natallia@globalfundingexperts.com', 'yelena@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'contract_requested',
  'Returned deposits withdrawals',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['contracts@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'inv_deposit_mismatch',
  'Inv deposit mismatch',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['yelena@globalfundingexperts.com', 'maryna@globalfundingexperts.com', 'natallia@globalfundingexperts.com', 'bshaq@globalfundingexperts.com']
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to)
VALUES(
  'isorel_commission_invoice',
  'ISO rel commission invoice',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com'
);
"

pg_execute "
INSERT INTO emlconfig (tag, name, sender, reply_to, to_address)
VALUES(
  'collection_report',
  'Collection report',
  'accounting@globalfundingexperts.com',
  'accounting@globalfundingexperts.com',
  ARRAY['robert@globalfundingexperts.com', 'natallia@globalfundingexperts.com', 'rafi@globalfundingexperts.com', 'boris@globalfundingexperts.com', 'steve@globalfundingexperts.com', 'alex1989@globalfundingexperts.com', 'bshaq@globalfundingexperts.com', 'yelena@globalfundingexperts.com', 'maryna@globalfundingexperts.com', 'rep@globalfundingexperts.com', 'rep2@globalfundingexperts.com', 'rep3@globalfundingexperts.com', 'rep4@globalfundingexperts.com', 'rep5@globalfundingexperts.com']
);
"
