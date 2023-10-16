from singleton_decorator import singleton
from objcache import objcache_get_entire_table


@singleton
class UserConstants:

    def __init__(self, cnf):
        self._cnf = cnf

        self.login_stat_active = None
        self.login_stat_inactive = None
        self.login_stat_confirmed = None

        self.role_admin = None
        self.role_Lender = None
        self.role_Underwriter = None
        self.role_iso = None
        self.role_deactivated_iso = None
        self.role_deactivated_iso_relations = None
        self.role_iso_relations = None
        self.role_commission = None
        self.role_ins_commission = None
        self.role_mca_user = None
        self.role_accounting = None
        self.role_collection = None
        self.role_OfficeManager = None
        self.role_dataentry = None
        self.role_mcawfdashboard = None
        self.role_accounting_extern = None
        self.role_underwriter_limited = None
        self.role_FUT_INC_PREPARER = None
        self.role_FUT_INC_MAKER = None
        self.role_FUT_INC_CHECKER = None
        self.role_manager = None
        self.role_contract_fee = None
        self.role_investor_fee = None
        self.role_exec_approval = None
        self.role_ext_lawyer = None

        self._db_init(cnf)

        self.roles_iso_isorel = [self.role_iso, self.role_iso_relations]
        self.roles_comuser = [self.role_iso, self.role_iso_relations, self.role_commission,
                              self.role_ins_commission]

    def _db_init(self, cnf):
        for item in objcache_get_entire_table(cnf, 'loginstatus'):
            (rec_id, property_name) = (item['id'], item['property_name'])

            if property_name and len(property_name) > 0:
                setattr(self, property_name, rec_id)

        for item in objcache_get_entire_table(cnf, 'userrole'):
            (rec_id, property_name) = (item['id'], item['property_name'])

            if property_name and len(property_name) > 0:
                setattr(self, property_name, rec_id)
