from singleton_decorator import singleton


@singleton
class RefRolesConstants:

    def __init__(self, cnf):
        self._cnf = cnf

        self.ref_roles_id = {}
        self.ref_roles_name = {}

        self.ref_roles_on_contract = None
        self.ref_roles_best_contact = None
        self.ref_roles_acct_rec_contact = None
        self.ref_roles_trade_ref_contact = None

        self._inint_reference_roles()


    def _inint_reference_roles(self):
        self.ref_roles_id = {
            0: 'On contract',
            1: 'Best contact',
            2: 'Account Receivables Contact',
            3: 'Trade Reference Contact'
        }

        self.ref_roles_name = {v: k for k, v in self.ref_roles_id.items()}

        self.ref_roles_on_contract = self.ref_roles_name['On contract']
        self.ref_roles_best_contact = self.ref_roles_name['Best contact']
        self.ref_roles_acct_rec_contact = self.ref_roles_name['Account Receivables Contact']
        self.ref_roles_trade_ref_contact = self.ref_roles_name['Trade Reference Contact']
