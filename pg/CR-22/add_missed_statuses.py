#!/usr/bin/env python

import psycopg2
from datetime import datetime
from collections import defaultdict
from mcahelpers import mca_get_processing_fee_old, mca_get_base_fields, mca_get_by_ids
from utils import get_mongo_collection, AppConstants, \
    pg_return_connection, pg_get_connection, pg_list, McaConstants, \
    pg_get_many, pg_get, pg_execute
from jobs.jobutils import run_app
from jobs.jobutils import setup_common_pars_args
from utils import get_next_id, pg_create


def _load_statuses(cnf):
    return {i['status']: i['_id'] for i in get_mongo_collection(cnf, 'statuses').find({})}


def _process(cnf):
    col = get_mongo_collection(cnf, 'mca')

    pos_list = pg_get_many(cnf, '{schema}.mcaposition', {'status': 0})
    ids = [i['mcaid'] for i in pos_list]
    uniq = {}

    print('Found statuses')
    for mca in col.find({'_id': {'$in': ids}}, {"status": True}):
        status = mca.get('status', '')

        if status in uniq:
            uniq[status] += 1
        else:
            uniq[status] = 1

    for status, cnt in uniq.items():
        print('%s: %s' % (status, cnt))

    print('')

    all_statuses = _load_statuses(cnf)
    print(all_statuses)
    col_statuses = get_mongo_collection(cnf, 'statuses')

    max_id = None

    for status, cnt in uniq.items():
        if not isinstance(status, str) or status == '':
            print('Skipping: %s' % status)
            continue

        res = {
            '_id': get_next_id(cnf, 'mcastatuses'),
            'status': status,
            'category': 'Other'
        }

        if status not in all_statuses:
            print('Saving status in mongo: %s' % status)
            status_id = get_next_id(cnf, 'mcastatuses')
            rec = {
                '_id': status_id,
                'status': status,
                'category': 'Other'
            }
            col_statuses.insert_one(rec)
        else:
            status_id = all_statuses[status]

        pg_rec = pg_get(cnf, 'mcastatus', status_id)

        if not pg_rec:
            max_id = status_id
            print('Saving status in postgres: %s' % status)
            prop = status.strip('-').strip(' ').replace(' ', '_') \
                .replace('-', '').replace('(', '').replace(')', '') \
                .replace('.', '').replace('/', '_').lower().replace("'", '') \
                .replace('__', '_')
            prop = 'mca_status_' + prop
            pg_rec = {
                'id': status_id,
                'status': status,
                'category': 'Other',
                'property_name': prop
            }
            pg_create(cnf, 'mcastatus', pg_rec)

    if max_id is not None:
        con = pg_get_connection(cnf['pg'])
        cur = con.cursor()
        sql = 'ALTER SEQUENCE mcastatus_id_seq RESTART WITH %s' % (max_id + 1)
        cur.execute(sql)
        con.commit()
        pg_return_connection(con)

    return True


if __name__ == '__main__':
    parser = setup_common_pars_args('Convert core contract to PG')
    args = parser.parse_args()
    run_app(args, 'user2pg', _process)
