#!/usr/bin/env python


import logging
import psycopg2
from psycopg2 import extras
from pymongo import MongoClient
from jobs.jobutils import setup_common_pars_args, run_app
from utils import pg_get_connection, get_mongo_collection, pg_get_many


def logit(msg):
    logging.getLogger(__name__).info(msg)


def get_data_from_mongodb(cnf, mgmt_fee_base_map, status_map):
    mcalenders = get_mongo_collection(cnf, 'migrate_mcalenders')
    
    status_mongo_pg_map = {
        'active': "acceptstatus_active",
        'lenedrreject': "acceptstatus_reject",
        'setup': "acceptstatus_setup",
        'lenedraccept': "acceptstatus_accept",
        'lenderreview': "acceptstatus_review",
    }
    
    values_to_insert = []

    for mcalender in mcalenders.find():
        warnings = []

        mcaid = mcalender.get('mcaid')

        if not mcaid:
            warnings.append('mcaid is empty')
        
        userid = mcalender.get('userId')

        if not userid:
            warnings.append('userId is empty')
        
        mgmt_fee_base = mgmt_fee_base_map.get(mcalender.get('mgmtFeeBase', '').upper())

        if not mgmt_fee_base:
            warnings.append('mgmt_fee_base: could not been mapped')

        part_pct = mcalender.get('partPtc')

        if part_pct is None:
            warnings.append('partPtc is None')
        
        status = status_map.get(status_mongo_pg_map.get(mcalender.get('status')))

        if not status:
            warnings.append('status: could not been mapped')

        if warnings:
            logit('=' * 80)
            logit(mcalender)
            for w in warnings:
                logit('Warning: ' + w)

        if not userid or not mcaid:
            continue

        values_to_insert.append({
            'bypayment_fee_pct': mcalender.get('byPaymnetDefManagementFee'),
            'mcaid': mcaid,
            'mgmt_fee_base': mgmt_fee_base,
            'part_pct': part_pct,
            'status': status,
            'upfront_fee_pct': mcalender.get('upfrontDefManagementFee'),
            'userid': userid,
            'visible_docs': mcalender.get('visibleDocs', []),
        })
        
    return values_to_insert


def get_status_map(cnf):
    res = pg_get_many(cnf, 'public.investoracceptstatus', {'1': 1})

    return {item['property_name']: item['id'] for item in res}


def get_mgmt_fee_base_map(cnf):
    res = pg_get_many(cnf, 'public.amountbaseindicator', {'1': 1})

    return {item['name']: item['id'] for item in res}


def upload_to_pg(cnf, data_from_mongo, pg_schema, pg_table):
    sql = '''
        INSERT INTO {}.{}
        (
            bypayment_fee_pct,
            mcaid,
            mgmt_fee_base,
            part_pct,
            status,
            upfront_fee_pct,
            userid,
            visible_docs
        )
        VALUES 
        (
            %(bypayment_fee_pct)s,
            %(mcaid)s,
            %(mgmt_fee_base)s,
            %(part_pct)s,
            %(status)s,
            %(upfront_fee_pct)s,
            %(userid)s,
            %(visible_docs)s
        )
        '''.format(pg_schema, pg_table)

    conn = pg_get_connection(cnf['pg'])
    cur = conn.cursor()
    cur.executemany(sql, data_from_mongo)
    conn.commit()
    conn.close()


def _process(cnf):
    mgmt_fee_base_map = get_mgmt_fee_base_map(cnf)
    status_map = get_status_map(cnf)

    data_from_mongo = get_data_from_mongodb(cnf, mgmt_fee_base_map, status_map)
    upload_to_pg(cnf, data_from_mongo, cnf['pg']['schema'], 'mcainvestors')


if __name__ == '__main__':
    parser = setup_common_pars_args('Migrate data from Mondo DB mcalenders to PG mcainvestors')
    args = parser.parse_args()
    run_app(args, 'investors2pg', _process)
