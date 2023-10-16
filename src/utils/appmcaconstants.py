from singleton_decorator import singleton

from objcache import objcache_get_entire_table


@singleton
class McaConstants:
    def __init__(self, cnf):
        self.status_name2id = {}
        self.status_id2name = {}
        self.mcapayment_name2id = {}
        self.mcapayment_id2name = {}
        self.mcaprogram_id2name = {}
        self.rates_contract_type = 1
        self.rates_discount_type = 2

        self.fill_mca_statuses(cnf)
        self.fill_mcapayment_statuses(cnf)
        self.fill_mcaprogram_statuses(cnf)

    def _mca_agg_status_convert(self, cnf, names, agg_name):
        res = []

        for status in cnf['mca'][agg_name]:
            if status in names:
                res.append(names[status])

        return res

    def fill_mca_statuses(self, cnf):
        for i in objcache_get_entire_table(cnf, 'mcastatus', True):
            self.status_name2id[i['status']] = i['id']
            self.status_id2name[i['id']] = i['status']
            setattr(self, i['property_name'], i['id'])

        self.agg_mca_status_funded = self._mca_agg_status_convert(
            cnf, self.status_name2id, 'statusFunded')
        self.agg_mca_status_inprogress = self._mca_agg_status_convert(
            cnf, self.status_name2id, 'statusInProgress')

        for k, v in cnf['mca']['status_map'].items():
            if v not in self.status_name2id:
                continue

            cnf['mca']['status_map'][k] = self.status_name2id[v]

        keys_list = ['statusDone', 'statusFunded', 'statusInProgress',
            'statusPreapproved', 'statusDeclined']

        for name in keys_list:
            for i, val in enumerate(cnf['mca'][name]):
                if val not in self.status_name2id:
                    continue

                cnf['mca'][name][i] = self.status_name2id[val]

        return True

    def mca_status_name2id(self, name):
        return self.status_name2id.get(name, 0)

    def mca_status_id2name(self, sid):
        return self.status_id2name.get(sid, sid)

    def fill_mcapayment_statuses(self, cnf):
        for i in objcache_get_entire_table(cnf, 'mcapaymentstatus', True):
            name, prop, sid = i['name'], i['property_name'], i['id']
            self.mcapayment_name2id[name] = sid
            self.mcapayment_id2name[sid] = name
            setattr(self, prop, sid)

        return True

    def mca_paymentstatus_name2id(self, name):
        return self.mcapayment_name2id[name]

    def fill_mcaprogram_statuses(self, cnf):
        for item in objcache_get_entire_table(cnf, 'mcaprogram', True):
            sid, property_name = item['id'], item['property_name']
            setattr(self, property_name, sid)
            self.mcaprogram_id2name[sid] = item['name']

    def mca_program_id2name(self, sid):
        return self.mcaprogram_id2name[sid]

    def funding_type_map(self, ftype):
        if isinstance(ftype, int) or ftype.isnumeric():
            return int(ftype)
        elif ftype == 'Fixed Daily ACH':
            return self.mcaprogram_deal
        elif ftype == 'Consolidation ACH':
            return self.mcaprogram_consolidation
        elif ftype == 'Incremental Deal':
            return self.mcaprogram_incremental

        return 0

    def status_funded_list(self):
        return [
            self.mca_status_funded,
            self.mca_status_funded_na
        ]
