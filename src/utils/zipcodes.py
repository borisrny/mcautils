from dbutils import pg_get


def list_zipcodes(cnf, zipcode):
    pg_table = cnf['pg']['refmodules'].get('zipcodes')
    if pg_table is not None:
        ret = pg_get(cnf, pg_table, zipcode, idfield='zipcode') or {}
        return ret
    else:
        return {}
