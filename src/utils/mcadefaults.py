from dbutils.general import get_mongo_collection


def mcadef_get(cnf, proj):
    """
    get defaults
    :param cnf:
    :param proj:
    :return:
    """
    col = get_mongo_collection(cnf, 'mcaDefaults')
    return col.find_one({'_id': 1}, proj)


def mcadef_get_emails(cnf, tag):
    res = []
    # if tag:
    #     rec = mcadef_get(cnf, {tag: True}).get(tag, [])
    #     if isinstance(rec, list):
    #         res = rec
    #     else:
    #         res = rec.split(',')
    # tmp = mcadef_get(cnf, {'emlAll': True}).get('emlAll', [])
    # if tmp:
    #     res.append(tmp)
    return res
