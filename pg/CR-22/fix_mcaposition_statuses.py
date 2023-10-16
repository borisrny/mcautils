#!/usr/bin/env python

import psycopg2
from datetime import datetime
from collections import defaultdict
from mcahelpers import mca_get_processing_fee_old, mca_get_base_fields, mca_get_by_ids
from utils import get_mongo_collection, AppConstants, \
    pg_return_connection, pg_get_connection, pg_list, McaConstants, \
    pg_get_many, pg_get, pg_execute, pg_update_cond
from jobs.jobutils import run_app
from jobs.jobutils import setup_common_pars_args
from utils import get_next_id, pg_create


def _load_statuses(cnf):
    return {i['status']: i['_id'] for i in get_mongo_collection(cnf, 'statuses').find({})}


def _process(cnf):
    col = get_mongo_collection(cnf, 'mca')

    pos_list = pg_get_many(cnf, '{schema}.mcaposition', {'status': 0})
    ids = [i['mcaid'] for i in pos_list]
    all_statuses = _load_statuses(cnf)

    for mca in col.find({'_id': {'$in': ids}}, {"status": True}):
        status = mca.get('status', '')
        mcaid = mca.get('_id')

        if status not in all_statuses:
            print('Status is not found: %s' % status)
            continue

        status_id = all_statuses[status]

        pg_update_cond(cnf, '{schema}.mcaposition', {'status': status_id},
                       {'mcaid': mcaid}, retid='mcaid')

    return True


if __name__ == '__main__':
    parser = setup_common_pars_args('Convert core contract to PG')
    args = parser.parse_args()
    run_app(args, 'user2pg', _process)
