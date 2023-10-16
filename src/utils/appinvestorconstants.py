from singleton_decorator import singleton
from objcache import objcache_get_entire_table


@singleton
class InvestorConstants:
    def __init__(self, cnf):
        self.acceptstatus = {}

        for status in objcache_get_entire_table(cnf, 'investoracceptstatus', True):
            self.acceptstatus[status['property_name']] = status['id']
            setattr(self, status['property_name'], status['id'])
