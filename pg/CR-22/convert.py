#!/usr/bin/env python

from datetime import datetime

from dbutils import get_mongo_collection, pg_list, pg_return_connection, pg_get_connection
from mcahelpers import mca_get_processing_fee_old
from jobs.jobutils import run_app
from jobs.jobutils import setup_common_pars_args
from utils import McaConstants

mcastatuses = {}
payment_status = {}


def _load_statuses(cnf):
    global mcastatuses
    mcastatuses = {i['status']: i['_id'] for i in get_mongo_collection(cnf, 'statuses').find({})}
    global payment_status
    payment_status = {i['name']: i['id'] for i in pg_list(cnf, 'mcapaymentstatus')}


def _fill_mcafinance(cnf, con, mca):
    global mcastatuses
    global payment_status

    n20 = lambda x: x if x else 0

    mca_consts = McaConstants(cnf)
    fa = round(mca.get('fundingAmountRequested', 0), 2)
    fee_amt = round(mca_get_processing_fee_old(mca), 2)
    fee_pct = round(fee_amt / fa * 100 if fa > 0 else 0, 4)
    tmp = mca.get('achWithdrawalAmt', 0)
    withdr_amt = round(tmp, 2) if tmp is not None else 0
    mid = mca['_id']
    sql = 'INSERT INTO {}.mcaposition ' \
          '(mcaid,program,funding_amount,fee_pct,payment_amount,payment_freq,status,' \
          'payment_status,status_reason_id,create_timestamp,deposit_freq) ' \
          'VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'.format(cnf['pg']['schema'])
    cur = con.cursor()
    program = mca_consts.funding_type_map(mca.get('fundingType', ''))

    if program == 0:
        program = 1

    cur.execute(sql, (
        mid,
        program,
        fa,
        fee_pct,
        withdr_amt,
        mca.get('withdFreq', 1),
        mcastatuses.get(n20(mca.get('status')), 0),
        payment_status.get(mca.get('paymentStatus', ''), 1),
        mca.get('statusreasonid'),
        mca.get('create_timestamp'),
        mca.get('depFreq', 1)
    ))
    cur.close()


def _fill_mcastatus(cnf, con):
    cur = con.cursor()
    max_id = None

    for item in get_mongo_collection(cnf, 'statuses').find({}):
        status = item['status']
        sid = item['_id']
        category = item['category']

        if max_id is None or sid > max_id:
            max_id = sid

        prop = status.strip('-').strip(' ').replace(' ', '_') \
            .replace('-', '').replace('(', '').replace(')', '') \
            .replace('.', '').replace('/', '_').lower().replace("'", '') \
            .replace('__', '_')
        prop = 'mca_status_' + prop

        sql = 'INSERT INTO mcastatus(id, status, category, property_name) VALUES(%s, %s, %s, %s) '

        try:
            cur.execute(sql, (sid, status, category, prop))
        except Exception as e:
            print('Failed to add: id=%s, status=%s, category=%s, property_name=%s' \
                  % (sid, status, category, prop))
            print('Error: %s' % str(e))

    sql = 'ALTER SEQUENCE mcastatus_id_seq RESTART WITH %s' % (max_id + 1)

    cur.execute(sql)

    cur.close()


def _fill_rate(cnf, con, mca):
    mid = mca['_id']
    sql = 'INSERT INTO {}.mcarate (mcaid,rate,current,rate_type) ' \
          'VALUES (%s,%s,%s,%s)'.format(cnf['pg']['schema'])

    factor_rate = mca.get('factorRate')
    d_factor_rate = mca.get('discountFactorRate')
    use_discount = mca.get('useDiscountRate', False)
    cur = con.cursor()
    if factor_rate is not None:
        cur.execute(sql, (mid, factor_rate, not use_discount, 1))
    if d_factor_rate is not None and d_factor_rate > 0.00001:
        cur.execute(sql, (mid, d_factor_rate, use_discount, 2))
    cur.close()


def _clean(cnf, con):
    cur = con.cursor()
    cur.execute('DELETE FROM %s.mcaposition' % cnf['pg']['schema'])
    cur.execute('DELETE FROM mcastatus WHERE id!=0')
    cur.close()


def _process(cnf):
    print(datetime.now())
    con = pg_get_connection(cnf['pg'])
    con.autocommit = True
    col = get_mongo_collection(cnf, 'mca')

    print('Start Clean')
    _clean(cnf, con)
    print('Start _load_statuses')
    _load_statuses(cnf)
    print('Start _fill_mcastatus')
    _fill_mcastatus(cnf, con)

    count = 1000
    counts = 0
    for mca in col.find({},
                        {'_id': True, 'fundingType': True, 'fundingAmountRequested': True,
                         'adminUnderwritingFees': True, 'withdFreq': 1, 'achWithdrawalAmt': True,
                         'factorRate': True, 'discountFactorRate': True, 'useDiscountRate': True,
                         'status': True, 'paymentStatus': True, 'statusreasonid': True,
                         'create_timestamp': True, 'depFreq': True}):
        count -= 1
        if count == 0:
            counts += 1
            count = 1000
            print('{} Processed {} deals'.format(datetime.now(), counts*1000))
        _fill_mcafinance(cnf, con, mca)
        _fill_rate(cnf, con, mca)

    con.commit()
    pg_return_connection(con)
    print(datetime.now())


if __name__ == '__main__':
    parser = setup_common_pars_args('Convert core contract to PG')
    args = parser.parse_args()
    run_app(args, 'user2pg', _process)
