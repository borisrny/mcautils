from objcache import objcache_get_entire_table


def util_get_ach_config(cnf):
    return objcache_get_entire_table(cnf, '{}.achvenue'.format(cnf['pg']['schema']))
