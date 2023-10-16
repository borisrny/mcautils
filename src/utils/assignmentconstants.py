from singleton_decorator import singleton

@singleton
class AssignmentConstants:

    def __init__(self, cnf):
        self._cnf = cnf

        self.ar_status_id = {}
        self.ar_status_name = {}

        self.ar_active = None
        self.ar_active_funds_frozen = None
        self.ar_inactive_no_funds = None

        self._init_assignment_status()


    def _init_assignment_status(self):
        self.ar_status_id = {
            1: 'Active AR',
            2: 'Active AR (Funds Frozen)',
            3: 'Inactive AR (No Funds)'
        }

        self.ar_status_name = {v: k for k, v in self.ar_status_id.items()}

        self.ar_active = self.ar_status_name['Active AR']
        self.ar_active_funds_frozen = self.ar_status_name['Active AR (Funds Frozen)']
        self.ar_inactive_no_funds = self.ar_status_name['Inactive AR (No Funds)']
