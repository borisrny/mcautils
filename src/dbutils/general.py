'''
Created on May 2, 2017

@author: boris
'''

from datetime import datetime
from pymongo import DESCENDING, ASCENDING

from dbutils import pg_list
from .dbuseradmin import db_get_db


def get_next_id(cnf, table):
    col = get_mongo_collection(cnf, cnf['mongoDB']['count_col'])
    res = col.find_one_and_update({'_id': table},
                                  {'$inc': {'seq': 1}},
                                  upsert=True, new=True)
    return int(res['seq'])


def get_entire_collection(cnf, name, order=None, proj=None):
    return _get_mongo_tbl(cnf, name, order, proj)


def get_entire_collection_by(cnf, name, fltr, order=None):
    col = get_mongo_collection(cnf, name)
    if not order:
        order = {'field': '_id', 'dir': 0}
    res = col.find(fltr).sort(order['field'], ASCENDING if order['dir'] == 0 else DESCENDING)
    return mongo_id_to_str(res)


def get_val_by_id(cnf, name, rid, projection=None):
    col = get_mongo_collection(cnf, name)
    res = col.find_one({'_id': rid}, projection)
    return res


def get_val_by_tag(cnf, name, tag, val):
    col = get_mongo_collection(cnf, name)
    res = col.find_one({tag: val})
    return res


def replace_record(cnf, name, rid, doc):
    col = get_mongo_collection(cnf, name)
    res = col.replace_one({'_id': rid}, doc, upsert=True)
    return {'mod_count': res.modified_count}


def update_by_id(cnf, name, rid, doc):
    col = get_mongo_collection(cnf, name)
    if rid != 'refrecordreplace':
        setobj = {'$set': doc}
        res = col.update_one({'_id': int(rid)}, setobj)
        return {'mod_count': res.modified_count}
    else:
        rid = doc.pop('_id')
        res = col.replace_one({'_id': int(rid)}, doc)
        return {'mod_count': res.modified_count}


def update_by_tag(cnf, name, tag, val, doc):
    col = get_mongo_collection(cnf, name)
    setobj = {'$set': doc}
    res = col.update_one({tag: val}, setobj, upsert=True)
    return {'mod_count': res.modified_count}


def create_record(cnf, name, doc):
    col = get_mongo_collection(cnf, name)
    doc['_id'] = get_next_id(cnf, cnf['mongoDB'][name])
    res = col.insert_one(doc)
    return {'_id': res.inserted_id}


def delete_by_id(cnf, name, rid):
    col = get_mongo_collection(cnf, name)
    res = col.delete_one({'_id': rid})
    return {'delete_count': str(res.deleted_count)}


def get_mongo_collection(cnf, name):
    cnf_mongo = cnf['mongoDB']
    db = db_get_db(cnf)
    return db[cnf_mongo[name]]


def mongo_id_to_str(res):
    lst = [i for i in res]
    return lst


def list_states(_):
    states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA",
              "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
              "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
              "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
              "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    return states


def list_priorities(cnf):
    return cnf['general']['priorities']


def list_btcc(cnf):
    return cnf['general']['btcc']


def list_business_types(cnf):
    pg_table = cnf['pg']['refmodules'].get('businesstypes')
    if pg_table is not None:
        return pg_list(cnf, pg_table)


def list_industry_types(cnf):
    return _get_mongo_tbl(cnf, 'col_industry_types')


def _get_mongo_tbl(cnf, name, order=None, proj=None):
    col = get_mongo_collection(cnf, name)
    if not order:
        order = {'field': '_id', 'dir': 0}
    if proj is None:
        proj = {}
    res = col.find({}, proj).sort(order['field'], ASCENDING if order['dir'] == 0 else DESCENDING)
    return mongo_id_to_str(res)


def set_default_tags(doc, user):
    doc['update_user'] = user
    doc['create_user'] = user
    tm_now = datetime.utcnow()
    doc['update_timestamp'] = tm_now
    doc['create_timestamp'] = tm_now
    if 'parentId' not in doc:
        doc['parentId'] = int(doc['_id'])
