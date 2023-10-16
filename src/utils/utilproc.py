import logging
from os import utime, path, remove


def _util_get_lock_file(cnf, procname):
    lockdir = cnf.get('lockdir', '/tmp')
    return '/'.join((lockdir, procname))


def util_lock_process(cnf, procname):
    fname = _util_get_lock_file(cnf, procname)
    if path.isfile(fname):
        logging.getLogger(__name__).debug('Lock file exists: {}'.format(fname))
        return False
    with open(fname, 'a'):
        utime(fname, None)
    logging.getLogger(__name__).debug('Lock file name: {}'.format(fname))
    return True


def util_unlock_process(cnf, procname):
    fname = _util_get_lock_file(cnf, procname)
    remove(fname)
    logging.getLogger(__name__).debug('Lock file {} removed'.format(fname))
