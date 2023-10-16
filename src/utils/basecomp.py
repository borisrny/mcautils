'''
Created on Sep 4, 2017

@author: boris
'''

import logging

from pymongo import ASCENDING

from dbutils import get_mongo_collection, update_aud, get_next_id


def comp_update(cnf, obj_type, oid, comp, compid, doc, user):
    if comp in cnf[obj_type]['external_comps']:
        collection = get_mongo_collection(cnf, comp)
        rid = int(doc.pop('_id', compid))
        if rid:
            collection.update_one({'_id': rid},
                                  {'$set': doc},
                                  upsert=True)
            return {'id': rid}
    raise Exception('Unimplemented')


def component_update(cnf, obj_type, oid, comp, doc, user):
    oid = int(oid)
    if comp in cnf[obj_type]['external_comps']:
        return _component_update_ext(cnf, obj_type, oid, comp, doc, user)

    col = get_mongo_collection(cnf, obj_type)
    saveDoc = {}
    if isinstance(doc, dict):
        if len(doc):
            for k, v in doc.items():
                saveDoc['.'.join((comp, k))] = v
        else:
            saveDoc[comp] = doc
    elif isinstance(doc, list):
        saveDoc[comp] = doc
    colaud = get_mongo_collection(cnf, 'audcollection')
    res = update_aud(cnf, col, oid, saveDoc, colaud, user)
    return {'id': res}


def component_get(cnf, obj_type, oid, comp, comp_id, user):
    if comp in cnf[obj_type]['external_comps']:
        return _component_get_ext(cnf, obj_type, oid, comp, comp_id, user)


def component_delete(cnf, obj_type, oid, comp, cid, user):
    if comp in cnf[obj_type]['external_comps']:
        col = get_mongo_collection(cnf, comp)
        res = col.delete_one({'_id': int(cid)})
        return {'delete_count': str(res.deleted_count)}


def _component_update_ext(cnf, obj_type, oid, comp, doc, user):
    collection = get_mongo_collection(cnf, comp)
    # Mongo replace - delete/insert
    refidname = obj_type + 'id'

    if isinstance(doc, list):
        try:
            collection.remove({refidname: oid})
        except Exception as ex:
            lg = logging.getLogger(__name__)
            lg.exception(ex)
        for rec in doc:
            rc = _component_update_ext_one(cnf, collection, comp, rec, refidname, oid)
        return {'mod_count': len(doc)}
    else:
        return _component_update_ext_one(cnf, collection, comp, doc, refidname, oid)


def _component_update_ext_one(cnf, collection, comp, rec, refidname, oid):
    rec[refidname] = oid
    rid = int(rec.get('_id', 0))
    if rid:
        rec.pop('_id')
        rc = collection.update_one({'_id': rid},
                                   {'$set': rec},
                                   upsert=True)
        return {'id': rid}
    else:
        rec['_id'] = get_next_id(cnf, comp)
        rc = collection.insert_one(rec)
        return {'id': rc.inserted_id}


def _component_get_ext(cnf, obj_type, oid, comp, comp_id, user):
    collection = get_mongo_collection(cnf, comp)
    if comp_id == -1:
        refidname = obj_type + 'id'
        return [i for i in collection.find({refidname: oid}).sort('_id', ASCENDING)]
    else:
        return collection.find_one({"_id": comp_id})

