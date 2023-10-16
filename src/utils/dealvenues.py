from singleton_decorator import singleton

from objcache import objcache_get_entire_table
from utils import util_get_ach_config
from appexcept import ACHLogicalException


@singleton
class DealVenuesConstants:
    def __init__(self, cnf):
        self.venues = {}
        self.venues_report = None
        self._db_init(cnf)

    def _db_init(self, cnf):
        self.venues = {rec['id']: rec['code'] for rec in
                       objcache_get_entire_table(cnf, '{}.dealvenue'.format(cnf['pg']['schema']))}

    def get_venues(self, cnf):
        if self.venues_report is None:
            self.venues_report = {}

            for v_id, v_code in self.venues.items():
                if v_code not in cnf['firmInfo']:
                    continue

                self.venues_report[v_id] = v_code

        return self.venues_report


@singleton
class DealVenues:
    def __init__(self, cnf):
        self.venues = util_get_ach_config(cnf)
        self._cnf = cnf

    def get_config(self, dealvenue_id, conn_name):
        for v in self.venues:
            if v['dealvenueid'] == dealvenue_id:
                for proccessor in v['achprocessors']:
                    if proccessor['name'] == conn_name:
                        return proccessor['value']
                raise ACHLogicalException(-1, 'Unexpected connection name: {} deal venue: {}'
                                          .format(conn_name, dealvenue_id))
        raise ACHLogicalException(-1, 'Unexpected deal venue: {}'.format(dealvenue_id))

    def get_code_to_dealvenueid(self, code):
        for v in self.venues:
            if v['code'] == code:
                return v['dealvenueid']
        raise ACHLogicalException(-1, 'Unexpected deal code: {}'.format(code))

    def get_dealvenueid_to_code(self, dealvenue_id):
        for v in self.venues:
            if v['dealvenueid'] == dealvenue_id:
                return v['code']
        raise ACHLogicalException(-1, 'Unexpected venue id: {}'.format(dealvenue_id))

    def id_2_firminfo(self, venueid):
        venue_code = DealVenuesConstants(self._cnf).venues[venueid]
        return self._cnf['firmInfo'][venue_code]

    def get_account(self, venue_id):
        venue_code = DealVenuesConstants(self._cnf).venues[venue_id]
        return self.get_account_by_code(venue_code)

    def get_account_by_code(self, venue_code):
        node = self._cnf['achprocessor']['venue'][venue_code]
        return {
            'account': node['acct'],
            'routing': node['routing'],
        }

@singleton
class SharedAccountVenueMap:
    """
    Maps venue codes to the target account venue code and related operations
    """
    def __init__(self, cnf: dict):
        dv = DealVenues(cnf)
        self.targetVenue = {}
        for target, venues in cnf.get('sharedAccountVenueMap', {}).items():
            tgt = dv.get_code_to_dealvenueid(target)
            for v in venues:
                self.targetVenue[dv.get_code_to_dealvenueid(v)] = tgt

    def get_target_venue(self, venue):
        return self.targetVenue.get(venue, venue)

    def same_target_venue(self, venue_1, venue_2):
        """
        check if both venues map to the same target venue
        """
        return venue_1 == venue_2 or self.get_target_venue(venue_1) == self.get_target_venue(venue_2)
