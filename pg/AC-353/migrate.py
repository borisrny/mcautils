#!/usr/bin/env python

import json
import logging
from dbutils import get_mongo_collection, pg_create, pg_count_by_field, pg_execute_select
from utils import AppConstants, AppRefType
from jobs.jobutils import setup_common_pars_args, run_app
from appexcept.appexcept import AppLogicalError


def migrate_bank_account_rec(cnf, mcaid, doc):
    const = AppRefType(cnf)
    rec = doc.get('rec', {})

    if not isinstance(rec, dict):
        logging.error('Invalid rec for mcaid=%s, rec=%s' % (mcaid, rec))
        rec = {}

    is_active = doc.get('acct', False)

    if doc.get('dflt', False):
        is_active = True

    data = {
        'account': rec.get('account'),
        'routing': rec.get('routing'),
        'name': rec.get('name'),
        'contact': None,
        'phone': None,
        'address': json.dumps(rec.get('address', {})),
        'accounttype': rec.get('accounttype'),
        'ref_type': const.mca,
        'ref_id': mcaid,
        'is_active': is_active,
        'is_default': doc.get('dflt', False),
        'description': doc.get('description')
    }

    return pg_create(cnf, '{schema}.bankaccount', data)


def check_migration(cnf):
    const = AppRefType(cnf)
    cnt = pg_count_by_field(cnf, '{schema}.bankaccount', const.mca, 'ref_type')

    if cnt > 0:
        raise AppLogicalError(-1, 'Table bankaccount already has some migrated data')

    return True


def _get_proccessed_mcais(cnf):
    res = pg_execute_select(cnf, 'select ref_id from {schema}.bankaccount where ref_type=1')
    return set([i['ref_id'] for i in res])


def main(cnf):
    # check_migration(cnf)

    fltr = {}
    fields = {
        '_id': True,
        'merchantBancAccountRec': True
    }

    col = get_mongo_collection(cnf, 'mca')
    mca_list = list(col.find(fltr, fields))
    cnt = len(mca_list)

    proccesssed = _get_proccessed_mcais(cnf)

    for ind, mca in enumerate(mca_list, start=1):
        print("\r%s of %s" % (ind, cnt), end='', flush=True)

        if mca['_id'] in proccesssed:
            continue

        if 'merchantBancAccountRec' not in mca:
            continue

        accounts = mca['merchantBancAccountRec']

        if not isinstance(accounts, list):
            logging.error('Invalid merchantBancAccountRec, mcaid=%s, data=%s' \
                          % (mca['_id'], accounts))
            continue

        for i in accounts:
            migrate_bank_account_rec(cnf, mca['_id'], i)

    print('')

    return  True


if __name__ == '__main__':
    parser = setup_common_pars_args('Migrate mca bankaccount')
    args = parser.parse_args()
    run_app(args, 'migrate', main)
