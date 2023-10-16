#!/usr/bin/env python


import time
from psycopg2.extensions import AsIs
from collections import defaultdict
from pid.decorator import pidfile
from jobs.jobutils import setup_common_pars_args, run_app
from utils import get_mongo_collection, AppConstants
from utils import pg_create, pg_count_by_field, pg_get_many, pg_fetchone
from mcahelpers import mca_get_processing_fee


def create_mcaoffer_record(cnf, mca, commissionset, funding_type, amount, rates,
                           deposit_freq, deposit_qnt, deposit_amount, withdrawal_freq,
                           withdrawal_payment, withdrawal_qnt, withdrawal_amount, contract_fee_pct,
                           ach_for_deposits, ach_for_payments, fixed_payment, status,
                           created_at=None, userid=None):
    rlist = []
    for rate in rates:
        rlist.append('ROW(%s, null)::rate_offer' % rate)

    dlist = ['ROW(%s, %s, null)' % (deposit_qnt, deposit_amount)]
    wlist = ['ROW(%s, %s)::withdrawal_offer' % (withdrawal_qnt,
                                                withdrawal_amount)]

    return pg_create(cnf, '{schema}.mcaoffer', {
        'mcaid': mca['_id'],
        'commissionset': commissionset,
        'name': '',
        'funding_type': funding_type,
        'amount': amount,
        'rates': AsIs('ARRAY[%s]::rate_offer[]' % ','.join(rlist)),
        'deposit_freq': deposit_freq,
        'deposit': AsIs('ARRAY[%s]::deposit_offer[]' % ','.join(dlist)),
        'withdrawal_freq': withdrawal_freq,
        'withdrawal_payment': withdrawal_payment,
        'withdrawal': AsIs('ARRAY[%s]::withdrawal_offer[]' % ','.join(wlist)),
        'contract_fee_pct': contract_fee_pct,
        'ach_for_deposits': ach_for_deposits,
        'ach_for_payments': ach_for_payments,
        'fixed_payment': fixed_payment,
        'status': status,
        'created_at': created_at,
        'createuserid': userid,
        'updateuserid': userid
    })


def commission_offer_record(cnf, offerid, venueid, userid, percent,
                            contract_fee, base_type, paystrategy):
    return pg_create(cnf, '{schema}.commissionoffer', {
        'offerid': offerid,
        'venueid': venueid,
        'userid': userid,
        'percent': percent,
        'contract_fee': contract_fee,
        'base_type': base_type,
        'paystrategy': paystrategy
    })


def advances_offer_record(cnf, offerid, name, funding_date, funding_amount,
                          balance_asof, ignore_funding_date, calc_date, amount, factor_rate,
                          payment, balance, consolidate, buyout, refmcaid):
    return pg_create(cnf, '{schema}.advancesoffer', {
        'offerid': offerid,
        'name': name,
        'funding_date': funding_date,
        'funding_amount': funding_amount,
        'balance_asof': balance_asof,
        'ignore_funding_date': ignore_funding_date,
        'calc_date': calc_date,
        'amount': amount,
        'factor_rate': factor_rate,
        'payment': payment,
        'balance': balance,
        'consolidate': consolidate,
        'buyout': buyout,
        'refmcaid': refmcaid
    })


def mca_has_offers(cnf, mca):
    cnt = pg_count_by_field(cnf, '{schema}.mcaoffer',
                            mca['_id'], idfield='mcaid')
    return cnt > 0


def create_mcaoffer_from_offer(cnf, mca, offer):
    main = offer[0]
    funding_type = 1
    fee = mca_get_processing_fee(mca)
    fee_pct = 0

    if fee > 0 and main['fa'] != 0:
        fee_pct = fee / main['fa'] * 100

    consts = AppConstants(cnf)
    offer_status = McaOfferStatus(cnf)

    res = create_mcaoffer_record(cnf, mca,
                                 commissionset=main['setindex'],
                                 funding_type=funding_type,
                                 amount=main['fa'],
                                 rates=[main['rate']],
                                 deposit_freq=1,
                                 deposit_qnt=1,
                                 deposit_amount=main['fa'],
                                 withdrawal_freq=1,
                                 withdrawal_payment=main['payment'],
                                 withdrawal_qnt=main['term'],
                                 withdrawal_amount=main['payment'],
                                 contract_fee_pct=fee_pct,
                                 ach_for_deposits=mca['useACHForDeposits'],
                                 ach_for_payments=mca['useACHForPayments'],
                                 fixed_payment=True,
                                 status=offer_status.expired,
                                 created_at=main['createdate']
                                 )

    offerid = res['id']
    first = True

    for item in offer:
        fltr = {
            'mcaid': mca['_id'],
            'userid': item['userid'],
            'setindex': item['setindex']
        }

        comsn = pg_fetchone(cnf, '{schema}.mcacommisionuser', fltr)

        if not comsn:
            if first:
                first = False
                print('')
            print('Commission set is not found for mcaid=%s, %s' \
                  % (mca['_id'], dict(item)))
            continue

        comsn_amount = round(main['fa'] * item['commission'] / 100, 2)

        commission_offer_record(cnf,
                                offerid=offerid,
                                venueid=comsn['dealvenue'],
                                userid=item['userid'],
                                percent=item['commission'],
                                contract_fee=0,  # comsn['contract_fee_allocation'],
                                base_type=comsn['baseindicator'],
                                paystrategy=consts.comm_pay_strat_byincrement  # comsn['paystrategy']
                                )

    return True


def mca_migrate_offers(cnf, mca):
    fltr = {
        'mcaid': mca['_id']
    }

    group = defaultdict(list)
    for offer in pg_get_many(cnf, '{schema}.mcaeml', fltr):
        group[offer['agroup']].append(offer)

    for offer in group.values():
        create_mcaoffer_from_offer(cnf, mca, offer)

    return True


@pidfile(pidname='migrate_offers')
def main(cnf):
    fltr = {}
    fields = {
        '_id': True, 'adminUnderwritingFees': True, 'useACHForDeposits': True,
        'useACHForPayments': True
    }

    col = get_mongo_collection(cnf, 'mca')
    mca_list = list(col.find(fltr, fields))
    cnt = len(mca_list)

    for ind, mca in enumerate(mca_list, start=1):
        print("\r%s of %s" % (ind, cnt), end='', flush=True)

        if mca_has_offers(cnf, mca):
            continue

        mca_migrate_offers(cnf, mca)

    print('')

    return True


if __name__ == '__main__':
    parser = setup_common_pars_args('Migrate offers')
    args = parser.parse_args()
    run_app(args, 'mcaoffer', main)
