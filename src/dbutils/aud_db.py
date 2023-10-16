from builtins import str
from collections.abc import MutableMapping
from datetime import datetime
from pymongo import DESCENDING
from .general import get_mongo_collection, get_next_id


def flatten_list(l, parent_key='', sep='/'):
    items = []
    for k, v in enumerate(l):
        k = str(k)
        new_key = sep.join((parent_key, k)) if parent_key else k
        if isinstance(v, MutableMapping):
            items.extend(list(flatten_dict(v, new_key, sep=sep).items()))
        elif isinstance(v, list):
            items.extend(list(flatten_list(v, new_key, sep=sep).items()))
        else:
            items.append((new_key, v))
    return dict(items)


def flatten_dict(d, parent_key='', sep='/'):
    items = []
    for k, v in list(d.items()):
        k = k.replace('.', '/')
        new_key = sep.join((parent_key, k)) if parent_key else k
        if isinstance(v, MutableMapping):
            items.extend(list(flatten_dict(v, new_key, sep=sep).items()))
        elif isinstance(v, list):
            items.extend(list(flatten_list(v, new_key, sep=sep).items()))
        else:
            items.append((new_key, v))
    return dict(items)


def dict_diff(new_doc, old_doc):
    first = flatten_dict(new_doc)
    second = flatten_dict(old_doc)
    diff = {}
    # Check all keys in first dict
    for key in list(first.keys()):
        if key not in second:
            diff[key] = (first[key], str())
        elif first[key] != second[key]:
            diff[key] = (first[key], second[key])

    for key in list(second.keys()):
        if key not in first:
            diff[key] = (str(), second[key])
    return diff


def save_aud(cnf, mid, doc, userid):
    col = get_mongo_collection(cnf, 'mca')
    col_aud = get_mongo_collection(cnf, 'audcollection')
    return update_aud(cnf, col, mid, doc, col_aud, userid)


def update_aud(cnf, col, did, doc, colaud, user):
    fltr = {'_id': did}
    doc.pop('_id', None)
    doc.pop('id', None)
    doc.pop('position', None)
    prev = col.find_one_and_update(filter=fltr, update={'$set': doc},
                                   projection=list(doc.keys()),
                                   upsert=True)
    prev.pop('_id', None)
    prev.pop('update_timestamp', None)
    prev.pop('user', None)
    doc.pop('update_timestamp', None)
    doc.pop('user', None)
    difobj = dict_diff(doc, prev)
    if len(difobj):
        rec_doc = {'did': did, 'audcollection': col.name, 'user': user, 'timestamp': datetime.utcnow(),
                   'change': difobj, '_id': get_next_id(cnf, colaud.name)}
        colaud.insert_one(rec_doc)
    return did


def update_aud_get(cnf, col, did, doc, colaud, user):
    fltr = {'_id': did}
    doc.pop('_id', None)
    doc.pop('id', None)
    doc.pop('position', None)
    orig = col.find_one(fltr)
    prev = col.find_one_and_update(filter=fltr, update={'$set': doc},
                                   projection=list(doc.keys()),
                                   upsert=True)
    prev.pop('_id', None)
    prev.pop('update_timestamp', None)
    prev.pop('user', None)
    doc.pop('_id', None)
    doc.pop('update_timestamp', None)
    doc.pop('user', None)
    difobj = dict_diff(doc, prev)
    if len(difobj):
        rec_doc = {'did': did, 'audcollection': col.name, 'user': user.userid, 'timestamp': datetime.utcnow(),
                   'change': difobj, '_id': get_next_id(cnf, colaud.name)}
        colaud.insert_one(rec_doc)
    return prev, orig


def get_aud_history(cnf, colaud, module, mod_id):
    data = []
    filt = {'audcollection': module, 'did': mod_id}
    res = colaud.find(filt).sort('timestamp', DESCENDING)
    for r in res:
        obj = {'timestamp': r['timestamp'], 'user': r['user'], 'change': []}
        changes = {}
        for k, v in r['change'].items():
            obj['change'].append({
                'tag': k,
                'new': v[0],
                'old': v[1]
            })
        data.append(obj)
    return data
