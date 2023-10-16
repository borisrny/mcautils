#!/usr/bin/env python


import datetime
from jobs.jobutils import setup_common_pars_args, run_app
from businessevent import SubjectActions
from utils import AppConstants
from dbutils import pg_execute_select
from mca import mca_save_contract_changes


def _process(cnf):
    app_const = AppConstants(cnf)

    sql = 'SELECT b2.* ' \
          'FROM {schema}.businessevent b1, {schema}.businessevent b2 ' \
          'WHERE b1.subject_action->>\'action\'=\'{action_type}\' ' \
          'AND b1.subject_action->>\'event\'=\'accepted\' ' \
          'AND b2.id=b1.parent_id ' \
          'AND b2.subject_action->>\'action\'=\'{action_type}\' ' \
          'AND b2.subject_action->>\'rate_type\'=\'{rate_type}\' ' \
          'AND b2.subject_action->>\'event\'=\'action_requested\' ' \
          'ORDER BY b2.subject_id, b2.id ' \
          .format(
              schema=cnf['pg']['schema'],
              action_type=SubjectActions.mcarate,
              rate_type=app_const.rate_type_settlement
          )

    for r in pg_execute_select(cnf, sql):
        subject = r['subject_action']
        mca_save_contract_changes(cnf,
                                  mcaid=r['subject_id'],
                                  rate_type=subject.get('rate_type'),
                                  payment_amount=subject.get('payment'),
                                  payment_frequency=subject.get('frequency'))

    return True


if __name__ == '__main__':
    parser = setup_common_pars_args('Populate data to mca_contract_changes')
    args = parser.parse_args()
    run_app(args, 'investors2pg', _process)
