import logging
from datetime import datetime
from datetime import timedelta
from dbutils.general import get_mongo_collection
from dbutils.general import get_next_id
from appexcept.appexcept import AppLogicalError


class AppDBLogFormatter(logging.Formatter):
    DEFAULT_PROPERTIES = logging.LogRecord(
        '', '', '', '', '', '', '', '').__dict__.keys()

    def __init__(self, appname):
        self._appname = appname
        super(AppDBLogFormatter, self).__init__()

    def format(self, record):
        """Formats LogRecord into python dictionary."""
        # Standard document
        document = {
            'timestamp': datetime.utcnow(),
            'level': record.levelname,
            'message': record.getMessage(),
            'loggername': record.name,
            'filename': record.pathname,
            'module': record.module,
            'method': record.funcName,
            'linenumber': record.lineno,
            'appname': self._appname
        }
        # Standard document decorated with exception info
        if record.exc_info:
            document.update({
                'exception': {
                    'message': str(record.exc_info[1]),
                    'code': 0,
                    'stacktrace': self.formatException(record.exc_info)
                }
            })
            document['exceptiontext'] = str(record.exc_info[1])

        # Standard document decorated with extra contextual information
        if len(self.DEFAULT_PROPERTIES) != len(record.__dict__):
            contextual_extra = set(record.__dict__).difference(
                set(self.DEFAULT_PROPERTIES))
            if contextual_extra:
                for key in contextual_extra:
                    document[key] = record.__dict__[key]
        return document


class AppDBLogHandler(logging.Handler):

    def __init__(self, level=logging.NOTSET, cnf=None, appname=None):
        logging.Handler.__init__(self, level)
        self._cnf = cnf
        self.formatter = AppDBLogFormatter(appname)

    def emit(self, record):
        try:
            col = get_mongo_collection(self._cnf, 'mongologger')
            doc = self.format(record)
            doc['_id'] = get_next_id(self._cnf, 'mongologger')
            col.insert_one(doc)
        except Exception as ex:
            pass


def utils_log_mac_access(cnf, user, ip, mid):
    col = get_mongo_collection(cnf, 'logmcaaccess')
    col.insert_one({
        'timestamp': datetime.utcnow(),
        'user': user,
        'ip': ip,
        'mcaid': mid
    })

def utils_log_mac_access_get(cnf, params, user):
    """
    Log access has to be separate module...
    :param cnf:
    :param params:
    :param user:
    :return:
    """
    mongo_filter = {}
    if 'mcaid' in params:
        mongo_filter['mcaid'] = int(params['mcaid'])
    if 'startDate' in params and 'endDate' in params:
        start_date = datetime.strptime(params['startDate'], '%Y-%m-%d')
        end_date = datetime.strptime(params['endDate'], '%Y-%m-%d') + timedelta(days=1)
        mongo_filter['timestamp'] = {}
        mongo_filter['timestamp']['$gte'] = start_date
        mongo_filter['timestamp']['$lt'] = end_date
    if 'user' in params:
        mongo_filter['user'] = int(params['user'])
    if len(mongo_filter.keys()) == 0:
        raise AppLogicalError(-1, 'At least one filter must be used: [mcaid, user, startDate/endDate]')
    col = get_mongo_collection(cnf, 'logmcaaccess')
    return [{
        'mcaid': i.get('mcaid'),
        'user': i['user'],
        'timestamp': i['timestamp'],
        'ip': i['ip'],
    } for i in col.find(mongo_filter)]
