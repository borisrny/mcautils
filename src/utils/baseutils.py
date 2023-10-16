import yaml
from datetime import datetime

def load_config(fn):
    cnf = {}
    with open(fn, 'r') as ymlfile:
        cnf = yaml.load(ymlfile, Loader=yaml.FullLoader)
    for inc in cnf.get('include', []):
        cnf = merge_dict(cnf, yaml.load(open(inc), Loader=yaml.FullLoader))
    return cnf


def merge_dict(source, destination):
    for key, value in list(source.items()):
        if isinstance(value, dict):
            # get node or create one
            node = destination.setdefault(key, {})
            merge_dict(value, node)
        else:
            destination[key] = value

    return destination


def to_yes_no(value):
    return 'Yes' if bool(value) else 'No'


def reformat_datetime(datetime_str, output_format='%m/%d/%Y'):
    ts_formats = [
        '%Y-%m-%dT%H:%M:%S.%fZ',
        '%Y-%m-%d %H:%M:%S.%f'
    ]
    for ts_format in ts_formats:
        try:
            return datetime.strptime(datetime_str, ts_format).strftime(output_format)
        except:
            pass

    return datetime_str
