from os import getpid

import psycopg2
from psycopg2.extensions import AsIs
from psycopg2 import extras
from psycopg2.pool import ThreadedConnectionPool
import logging

from appexcept.appexcept import AppLogicalError

_pg_pool = None
dec2float = psycopg2.extensions.new_type(psycopg2.extensions.DECIMAL.values, 'dec2float',
                                         lambda value, curs: float(value) if value is not None else None)
psycopg2.extensions.register_type(dec2float)


class PGProcessPoolManager:
    def __init__(self, *args, **kwargs):
        self.last_seen_process_id = getpid()
        self.args = args
        self.kwargs = kwargs
        self._init()

    def _init(self):
        global _pg_pool
        self._pool = ThreadedConnectionPool(*self.args, **self.kwargs)
        self.last_seen_process_id = getpid()
        _pg_pool = self._pool

    def getconn(self):
        current_pid = getpid()
        if not (current_pid == self.last_seen_process_id):
            logging.getLogger(__name__).info(
                'New PG Pool. Current PID: {}, Old PID: {}'.format(current_pid, self.last_seen_process_id))
            self._init()
        return self._pool.getconn()

    def putconn(self, conn):
        if not (getpid() == self.last_seen_process_id):
            logging.getLogger(__name__).info(
                'Unexpected PID in PG Pool. Current PID: {}, Old PID: {}'.format(getpid(), self.last_seen_process_id))
            return
        return self._pool.putconn(conn)


class DictComposite(psycopg2.extras.CompositeCaster):
    def make(self, values):
        return dict(zip(self.attnames, values))


def _pg_connect(pgcnf):
    global _pg_pool
    logging.getLogger(__name__).info('Creating connection pool...')
    _pg_pool = PGProcessPoolManager(1, 1000, user=pgcnf['user'],
                                    password=pgcnf['pwd'],
                                    host=pgcnf['host'],
                                    port=pgcnf['port'],
                                    database=pgcnf['db'])


def pg_get_connection(pgcnf):
    global _pg_pool
    if not _pg_pool:
        _pg_connect(pgcnf)
    try:
        conn = _pg_pool.getconn()
        if not conn:
            raise Exception('PG connection not created')
    except Exception as ex:
        logging.getLogger(__name__).exception(ex)
        raise AppLogicalError(-1, 'Cannot connect to database.')
    return conn


def pg_return_connection(con):
    global _pg_pool
    _pg_pool.putconn(con)


def pg_reset_connection():
    global _pg_pool
    _pg_pool = None


def pg_intarray_to_in(ints):
    return ','.join([str(int(i)) for i in ints])


def pg_insert_doc(con, table, doc, do_commit):
    columns = doc.keys()
    values = [doc[column] for column in columns]
    sql = 'INSERT INTO {0} (%s) VALUES %s RETURNING id'.format(table)
    cur = con.cursor()
    stmt = cur.mogrify(sql, (AsIs(','.join(columns)), tuple(values)))
    cur.execute(stmt)
    recid = cur.fetchone()[0]
    if do_commit:
        con.commit()
    return recid


def pg_list(cnf, table, curs_dict=True, order_by=None):
    table = table.format(schema=cnf['pg']['schema'])
    cursor_factory = extras.RealDictCursor if curs_dict else None
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor(cursor_factory=cursor_factory)

    sql = 'SELECT * FROM {}'.format(table)

    if order_by:
        sql += ' ORDER BY ' + str(order_by)

    cur.execute(sql)

    data = [i for i in cur.fetchall()]
    cur.close()
    pg_return_connection(con)
    return data


def pg_get(cnf, table, recid, idfield='id'):
    table = table.format(schema=cnf['pg']['schema'])
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor(cursor_factory=extras.RealDictCursor)
    cur.execute('SELECT * FROM {} WHERE {}=%s'.format(table, idfield), (recid,))
    result = cur.fetchone()
    cur.close()
    pg_return_connection(con)
    return result


def pg_update(cnf, table, tid, doc, idfield='id'):
    table = table.format(schema=cnf['pg']['schema'])
    columns = doc.keys()
    values = [doc[column] for column in columns]
    set_vals = ','.join([i + '=%s' for i in columns])
    sql = 'UPDATE {0} SET {1} WHERE {3}={2} RETURNING {3}'.format(table, set_vals, tid, idfield)
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor()
    stmt = cur.mogrify(sql, (values))
    cur.execute(stmt)
    rc = cur.fetchone()
    cur.close()
    con.commit()
    pg_return_connection(con)
    if rc is None:
        raise AppLogicalError(-1, 'Failed to update {}/{}'.format(table, tid))
    return {'id': rc}


def pg_create(cnf, table, doc, idfield='id'):
    table = table.format(schema=cnf['pg']['schema'])
    columns = doc.keys()
    values = [doc[column] for column in columns]
    sql = 'INSERT INTO {0} (%s) VALUES %s RETURNING {1}'.format(table, idfield)
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor()
    stmt = cur.mogrify(sql, (AsIs(','.join(columns)), tuple(values)))
    cur.execute(stmt)
    recid = cur.fetchone()[0]
    con.commit()
    pg_return_connection(con)
    return {'id': recid}


def pg_count_by_field(cnf, table, recid, idfield='id'):
    table = table.format(schema=cnf['pg']['schema'])
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor()
    cur.execute('SELECT COUNT(*) FROM {} WHERE {}=%s'.format(table, idfield), (recid,))
    count = cur.fetchone()
    cur.close()
    pg_return_connection(con)
    return count[0]


def pg_delete(cnf, table, rec_id, idfield='id'):
    table = table.format(schema=cnf['pg']['schema'])
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor()
    cur.execute('DELETE FROM {} WHERE {}=%s'.format(table, idfield), (rec_id,))
    con.commit()
    pg_return_connection(con)
    return {'id': rec_id}


def pg_get_val(data, tag, default):
    res = data.get(tag, None)
    if res is None:
        res = default
    return res


def pg_tbl_count(cnf, tbl):
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor()
    cur.execute('SELECT COUNT(*) from {}.{}'.format(cnf['pg']['schema'], tbl))
    res = cur.fetchone()
    cur.close()
    pg_return_connection(con)
    return res[0]


def pg_execute_select(cnf, sql, sql_vals=None, con=None):
    return pg_execute(cnf, sql, sql_vals, con, True, True)


def pg_execute(cnf, sql, sql_vals=None, con=None, ret=True, is_select=False, curs_dict=True):
    cursor_factory = extras.RealDictCursor if curs_dict else None

    if sql_vals is None:
        sql_vals = tuple()

    if con is None:
        con = pg_get_connection(cnf['pg'])
        commit = True
    else:
        commit = False

    sql = sql.format(schema=cnf['pg']['schema'])

    cur = con.cursor(cursor_factory=cursor_factory)
    cur.execute(sql, tuple(sql_vals))

    if ret:
        data = [i for i in cur.fetchall()]
    else:
        data = True

    cur.close()

    if commit:
        if not is_select:
            con.commit()
        pg_return_connection(con)

    return data


def pg_execute_values(cnf, sql, sql_vals, con=None, template=None, page_size=100, fetch=False):
    if con is None:
        con = pg_get_connection(cnf['pg'])
        commit = True
    else:
        commit = False

    sql = sql.format(schema=cnf['pg']['schema'])

    cur = con.cursor()
    result = extras.execute_values(cur, sql, sql_vals, template, page_size, fetch)
    cur.close()

    if commit:
        con.commit()
        pg_return_connection(con)

    return result


def pg_build_where(fltr):
    """
    Build SQL where query with "AND" conditions
    :param fltr: filter values
    :return: tuple(sql where string, vars sequence)
    """
    if isinstance(fltr, list):
        sql_list = '%s,' * (len(fltr) - 1) + '%s'
        return ('id in ({})'.format(sql_list), tuple(fltr))

    if not isinstance(fltr, dict):
        return ('id=%s', (fltr,))

    cond = []
    vals = []
    for col, val in fltr.items():
        if isinstance(col, tuple):
            col = col[0]

        if isinstance(val, list):
            if col.endswith('<>'):
                operator = 'not in'
                col = col.rstrip('<>')
            else:
                operator = 'in'

            sql_list = '%s,' * (len(val) - 1) + '%s'
            cond.append('{} {} ({})'.format(col, operator, sql_list))
            vals.extend(val)
        else:
            if col.endswith('<>'):
                operator = '<>'
                col = col.rstrip('<>')
            elif col.endswith('>'):
                operator = '>'
                col = col.rstrip('>')
            elif col.endswith('<'):
                operator = '<'
                col = col.rstrip('<')
            elif col.endswith('>='):
                operator = '>='
                col = col.rstrip('>=')
            elif col.endswith('<='):
                operator = '<='
                col = col.rstrip('<=')
            elif col.endswith(' like'):
                operator = 'like'
                col = col[:-5].strip()
            else:
                if val is None:
                    operator = 'is'
                else:
                    operator = '='
            cond.append(str(col) + ' ' + operator + ' %s')
            vals.append(val)

    return (' AND '.join(cond), tuple(vals))


def pg_register_composite(cursor, composite):
    if isinstance(composite, list):
        for item in composite:
            psycopg2.extras.register_composite(item, cursor, factory=DictComposite)
    elif composite is not None:
        psycopg2.extras.register_composite(composite, cursor, factory=DictComposite)

    return True


def pg_get_many(cnf, table, filter_fields, fields='*', group_by=None, order_by=None,
                order_asc=True, composite=None, con=None, limit=None):
    if con is None:
        con = pg_get_connection(cnf['pg'])
        con_ret = True
    else:
        con_ret = False

    cur = con.cursor(cursor_factory=extras.RealDictCursor)

    if composite:
        pg_register_composite(cur, composite)

    (sql_cond, vals) = pg_build_where(filter_fields)

    sql = ['SELECT', fields, 'FROM', table, 'WHERE', sql_cond]

    if group_by is not None:
        sql.extend(['GROUP BY', group_by])

    if order_by is not None:
        order_direction = 'ASC' if order_asc else 'DESC'

        sql.extend(['ORDER BY', order_by, order_direction])

    if limit is not None:
        sql.extend(['LIMIT', str(limit)])

    sql = ' '.join(sql)
    cur.execute(sql.format(schema=cnf['pg']['schema']), vals)
    data = [i for i in cur.fetchall()]
    cur.close()

    if con_ret:
        pg_return_connection(con)

    return data


def pg_fetchone(cnf, table, fltr, fields='*', group_by=None,
                order_by=None, order_asc=True, composite=None):
    res = pg_get_many(cnf, table, fltr, fields, group_by,
                      order_by, order_asc, composite, limit=1)

    if res:
        return res[0]

    return None


def pg_update_cond(cnf, table, data, fltr, retid='id', extra_cond=None):
    cols = []
    vals = []
    for col, val in data.items():
        cols.append(col + '=%s')
        vals.append(val)

    (sql_cond, wvals) = pg_build_where(fltr)
    vals.extend(wvals)

    if extra_cond is not None:
        sql_cond += ' ' + extra_cond

    sql = 'UPDATE ' + table + ' SET ' + ', '.join(cols) \
          + ' WHERE ' + sql_cond + ' RETURNING {rid}'

    sql = sql.format(
        schema=cnf['pg']['schema'],
        rid=retid
    )

    con = pg_get_connection(cnf['pg'])
    cur = con.cursor(cursor_factory=extras.RealDictCursor)
    stmt = cur.mogrify(sql, (vals))
    cur.execute(stmt)
    con.commit()
    ret = [i for i in cur.fetchall()]
    cur.close()
    pg_return_connection(con)

    return ret


def pg_delete_cond(cnf, table, fltr, retid='id'):
    (sql_cond, vals) = pg_build_where(fltr)
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor(cursor_factory=extras.RealDictCursor)

    sql = 'DELETE FROM ' + table + ' WHERE ' + sql_cond \
          + ' RETURNING {retid}'

    sql = sql.format(
        schema=cnf['pg']['schema'],
        retid=retid
    )

    cur.execute(sql, vals)
    con.commit()
    ret = [i for i in cur.fetchall()]
    cur.close()
    pg_return_connection(con)

    return ret


def pg_upsert(cnf, table, data, idfield='id', retfield='id', con=None):
    table = table.format(schema=cnf['pg']['schema'])
    columns = data.keys()
    values = []
    update_list = []
    for column in columns:
        values.append(data[column])

        if column != idfield:
            update_list.append('{col}=EXCLUDED.{col}'.format(col=column))

    sql = 'INSERT INTO {table} (%s) VALUES %s ON CONFLICT ({id}) ' \
          ' DO UPDATE SET %s ' \
          ' RETURNING {rid} '.format(
        table=table,
        id=idfield,
        rid=retfield
    )

    if con is None:
        con = pg_get_connection(cnf['pg'])
        commit = True
    else:
        commit = False

    cur = con.cursor()
    stmt = cur.mogrify(sql, (
        AsIs(','.join(columns)),
        tuple(values),
        AsIs(','.join(update_list))
    ))

    cur.execute(stmt)
    recid = cur.fetchone()[0]
    cur.close()

    if commit:
        con.commit()
        pg_return_connection(con)

    return {'id': recid}


def pg_exec(cnf, sql, curs_dict=True):
    sql = sql.format(schema=cnf['pg']['schema'])
    cursor_factory = extras.RealDictCursor if curs_dict else None
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor(cursor_factory=cursor_factory)
    cur.execute(sql)
    data = [i for i in cur.fetchall()]
    cur.close()
    pg_return_connection(con)
    return data


def pg_get_many_as_dict(cnf, table, filter_fields, key_field):
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor(cursor_factory=extras.RealDictCursor)
    (sql_cond, vals) = pg_build_where(filter_fields)
    sql = ' '.join(['SELECT *', 'FROM', table.format(schema=cnf['pg']['schema']), 'WHERE', sql_cond])
    cur.execute(sql, vals)
    data = {i[key_field]: i for i in cur.fetchall()}
    cur.close()
    pg_return_connection(con)
    return data


def pg_get_table_columns(cnf, table):
    sql = f'SELECT * FROM {table} LIMIT 1'
    sql = sql.format(schema=cnf['pg']['schema'])
    con = pg_get_connection(cnf['pg'])
    cur = con.cursor(cursor_factory=extras.RealDictCursor)
    cur.execute(sql)
    column_names = [desc[0] for desc in cur.description]
    cur.close()
    pg_return_connection(con)
    return column_names


def pg_copy_rows(cnf, table, where, columns=[], static_columns={}):
    static_values = []
    insert_columns, select_columns = '', '*'
    if columns:
        select_columns = ', '.join(columns)
        insert_columns = f'({select_columns})'
        if static_columns:
            named_columns = []
            for column in columns:
                if column in static_columns:
                    named_columns.append(f'%s AS {column}')
                    static_values.append(static_columns[column])
                else:
                    named_columns.append(column)
            select_columns = ', '.join(named_columns)

    (where_sql, where_values) = pg_build_where(where)

    sql = f'INSERT INTO {table} {insert_columns} SELECT {select_columns} FROM {table} WHERE {where_sql} RETURNING *'

    return pg_execute(cnf, sql, tuple(static_values) + where_values)
