from singleton_decorator import singleton
from objcache import objcache_get_entire_table


@singleton
class AppRefType:

    def __init__(self, cnf):
        self.name2id = {}
        self.id2name = {}

        for i in objcache_get_entire_table(cnf, 'doc_ref_type', False):
            name, value = i[1], i[0]
            setattr(self, name, value)
            self.name2id[name] = value
            self.id2name[value] = name
