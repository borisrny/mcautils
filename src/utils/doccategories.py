from objcache import objcache_get_entire_table


def component_get_doc_categories(cnf):
    ret = {}
    for c in objcache_get_entire_table(cnf, cnf['pg']['refmodules']['doccategory']):
        ret[c['id']] = c['roles']
    return ret
