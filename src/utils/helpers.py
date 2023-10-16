import copy
import logging
from datetime import datetime
from email_validator import validate_email
from functools import reduce
from dateutil import relativedelta
from appexcept import AppLogicalError


def get_ammount(doc):
    ret = doc.get('ammount')
    if not ret:
        ret = 0
    return ret


def read_file(filename):
    fh = open(filename, "r")
    try:
        return fh.read()
    finally:
        fh.close()


def log_error(msg, *fvals):
    logging.getLogger(__name__).error(msg.format(*fvals))


def log_info(msg, *fvals):
    logging.getLogger(__name__).info(msg.format(*fvals))


def format_firm_info(firm_info, format_args):
    firm_info_copy = copy.deepcopy(firm_info)
    firm_info_copy['acroLong'] = firm_info_copy['acroLong'].format(**format_args)
    return firm_info_copy


def util_ui_date_to_date(date_str):
    if len(date_str) == 10:
        return datetime.strptime(date_str, '%Y-%m-%d').date()
    return datetime.strptime(date_str, '%Y-%m-%dT%H:%M:%S.%fZ').date()


def validate_date(date_str):
    try:
        datetime.strptime(date_str, '%Y-%m-%d')
    except ValueError:
        return False

    return True


def fmt_price(val):
    if isinstance(val, str):
        val = float(val)

    res = '{:,.2f}'.format(val)

    if res == '-0.00':
        return '0.00'

    return res


def util_email_validate(eml):
    try:
        validate_email(eml, check_deliverability=False)
        return True
    except Exception as ex:
        logging.getLogger(__name__).exception(ex)
        logging.getLogger(__name__).error('Invalid email: {}'.format(eml))
    return False


def nested_get(dictionary, keys, default=None):
    return reduce(lambda d, key: d.get(key, default) if isinstance(d, dict) else default, keys.split('.'), dictionary)


def term_to_human_readable(start_date, end_date, in_days=False):
    """Formating range between two days to human readable format
        - 10 day(s)
        - 1 year(s) 20 day(s)
        - 2 year(s) 1 month(s)
    """

    term_in_days = abs((end_date - start_date).days)
    term_str = '{} day(s)'.format(term_in_days)
    if not in_days:
        delta = relativedelta.relativedelta(end_date, start_date)
        term_str = ' '.join(
            ['{} {}'.format(item[0], item[1])
                for item in [
                    (delta.years, 'year(s)'),
                    (delta.months, 'month(s)'),
                    (delta.days, 'day(s)')
                ] if item[0] > 0]
        )
    return term_str

def validate_for_mandatory_fields(doc, mandatory_fields):
    for mandatory_field in mandatory_fields:
        field_value = nested_get(doc, mandatory_field, None)
        if field_value is None or \
                (isinstance(field_value, str) and field_value == '') or \
                (isinstance(field_value, list) and len(field_value) == 0):
            raise AppLogicalError(-1, f'Missed mandatory field: {mandatory_field}')
