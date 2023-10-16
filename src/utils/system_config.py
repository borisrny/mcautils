from singleton_decorator import singleton
from system_config import system_config_list

@singleton
class SystemConfigConstants:

    def __init__(self, cnf):
        self._cnf = cnf

        self.system_config_name = {}

        self.sys_default_venue = None
        self.sys_min_deposit_to_merchant_amount = None
        self.sys_min_last_payment_amount = None
        self.sys_same_day_ach_time_threshold = None
        self.sys_next_day_ach_time_threshold = None

        self._inint_system_config()


    def _inint_system_config(self):
        self.system_config_name = system_config_list(self._cnf)

        self.sys_default_venue = int(self.system_config_name['defaultVenue'])
        self.sys_min_deposit_to_merchant_amount = float(self.system_config_name['minDepositToMerchantAmount'])
        self.sys_min_deposit_last_to_merchant_amount = float(self.system_config_name['minDepositLastToMerchantAmount'])
        self.sys_min_last_payment_amount = float(self.system_config_name['minLastPaymentAmount'])
