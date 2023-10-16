#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

Q_TABLE="questions"
A_TABLE="answers"

pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${A_TABLE};"
pg_execute "DROP TABLE IF EXISTS %SCHEMA%.${Q_TABLE};"

pg_execute "
CREATE TABLE %SCHEMA%.${Q_TABLE}
(
  id SERIAL NOT NULL PRIMARY KEY,
  tag CHARACTER VARYING,
  dst_form CHARACTER VARYING NOT NULL,
  question TEXT NOT NULL,
  answer_type CHARACTER VARYING NOT NULL,
  answer_values TEXT[],
  answer_default CHARACTER VARYING,
  position INTEGER NOT NULL,
  CONSTRAINT dst_form_position_uniq UNIQUE (dst_form, position)
)
"

pg_execute "
CREATE TABLE %SCHEMA%.${A_TABLE}
(
  id SERIAL NOT NULL PRIMARY KEY,
  question_id INTEGER NOT NULL,
  doc_ref_type_id INTEGER NOT NULL,
  ref_id INTEGER NOT NULL,
  answer TEXT,
  CONSTRAINT question_id_fk FOREIGN KEY (question_id)
      REFERENCES %SCHEMA%.${Q_TABLE} (id) MATCH SIMPLE
      ON UPDATE NO ACTION
      ON DELETE NO ACTION,
  CONSTRAINT doc_ref_type_id_fk FOREIGN KEY (doc_ref_type_id)
      REFERENCES public.doc_ref_type (id) MATCH SIMPLE
      ON UPDATE NO ACTION
      ON DELETE NO ACTION,
  CONSTRAINT question_id_doc_ref_type_id_ref_id_uniq UNIQUE (question_id, doc_ref_type_id, ref_id)
)
"

pg_execute "
INSERT INTO %SCHEMA%.${Q_TABLE} (dst_form, tag, question, answer_type, answer_values, answer_default, position) VALUES
  ('mca_fundingcall_en', NULL, 'Hello, I''m calling on a recorded line. Before we begin, can you confirm you''re giving us your permission to record this call?', 'select', '{\"\", \"Yes\", \"No\"}', '', 1),
  ('mca_fundingcall_en', NULL, 'Can you confirm your Full Name and the last four of your SSN?', 'select', '{\"\", \"Confirmed\"}', '', 2),
  ('mca_fundingcall_en', NULL, 'Can you confirm your Business''s Legal Name?', 'select', '{\"\", \"Confirmed\"}', '', 3),
  ('mca_fundingcall_en', NULL, 'In case we get disconnected, can you confirm the best Phone Number and E-Mail to reach you.', 'select', '{\"\", \"Confirmed\"}', '', 4),
  ('mca_fundingcall_en', NULL, 'Can you briefly describe your business?', 'select', '{\"\", \"Confirmed\"}', '', 5),
  ('mca_fundingcall_en', NULL, 'Can you confirm what is your ownership % within the company?', 'select', '{\"\", \"Confirmed\"}', '', 6),
  ('mca_fundingcall_en', NULL, 'Are you authorized to sign and accept the terms of this contract agreement on behalf of the business?', 'select', '{\"\", \"Confirmed\"}', '', 7),
  ('mca_fundingcall_en', NULL, '(Only If Applicable) Confirm the Name and State of 3 clients from your A/R list or recent bank statement.', 'textarea', NULL, '', 8),
  ('mca_fundingcall_en', NULL, '(Only If Applicable) What is the name of your credit card processor?', 'textarea', NULL, '', 9),
  ('mca_fundingcall_en', NULL, 'How much % is your profit margin? (gross profit)', 'textarea', NULL, '', 10),
  ('mca_fundingcall_en', NULL, 'Did you read, understand and sign the contract via DocuSign?', 'select', '{\"\", \"Yes\", \"No\"}', '', 11),
  ('mca_fundingcall_en', 'statesToGenerateDisclosure', 'Did you read, understand and sign the Disclosure Form?', 'select', '{\"\", \"Yes\", \"No\"}', '', 12),
  ('mca_fundingcall_en', NULL, 'Do you understand that this is not a typical business loan, it''s a purchase of your future receivables?', 'select', '{\"\", \"Yes\", \"No\"}', '', 13),
  ('mca_fundingcall_en', NULL, 'Do you agree to allow GFE, to purchase the amount of \${c_rate_rtr} of your future receivables in exchange for a purchase price amount of \${funding_amt}?', 'select', '{\"\", \"Yes\", \"No\"}', '', 14),
  ('mca_fundingcall_en', NULL, 'Are you aware that you will be responsible for the \${withdr_freq} amount of \${payment_amount} from \${wf_range} until the MCA is satisfied?', 'select', '{\"\", \"Yes\", \"No\"}', '', 15),
  ('mca_fundingcall_en', 'fixedDailyACH', 'Are you aware that after the fees your business will net: \${net_to_merchant}?', 'select', '{\"\", \"Yes\", \"No\"}', '', 16),
  ('mca_fundingcall_en', 'consolidationACH', 'Are you aware that we''ll need to perform bank verification before each increment release and we''ll be unable to release the increments if your account is negative or if we''re unable to access your account?', 'select', '{\"\", \"Yes\", \"No\"}', '', 17),
  ('mca_fundingcall_en', 'consolidationACH', 'Are you aware that if you take any Merchant Cash Advances without receiving our permission, we may stop sending you increments and may charge you a stacking fee as specified on the fee page?', 'select', '{\"\", \"Yes\", \"No\"}', '', 18),
  ('mca_fundingcall_en', NULL, 'In order to get this advance, were you promised anything by anyone that''s not in this contract?', 'select', '{\"\", \"Yes\", \"No\"}', '', 19),
  ('mca_fundingcall_en', NULL, 'Please be advised that our NSF fee is \${nsf_fee}', 'select', '{\"\", \"Confirmed\"}', '', 20),
  ('mca_fundingcall_en', NULL, 'Please be advised that we''ll charge a \${monthly_fee} account management fee per month until the MCA is satisfied.', 'select', '{\"\", \"Confirmed\", \"Monthly Mgmt Fee waived\"}', '', 21)
"