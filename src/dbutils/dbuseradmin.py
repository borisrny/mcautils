import logging
from urllib.parse import quote_plus

from pymongo import MongoClient, database

from .monitormongo import MongoCmdMonitor


def db_get_client(cnf_mongo):
    uri = cnf_mongo['uri'].format(quote_plus(cnf_mongo['user']), quote_plus(cnf_mongo['pwd']), cnf_mongo['db'])
    return MongoClient(uri, event_listeners=[MongoCmdMonitor()])


def db_get_db(cnf):
    cnf_mongo = cnf['mongoDB']
    client = db_get_client(cnf_mongo)
    return client[cnf_mongo['db']]


def db_add_user(cnf, new_user, pwd, roles):
    logging.getLogger(__name__).info('Add user: {}'.format(new_user))
    cnf_mongo = cnf['mongoDB']
    client = db_get_client(cnf_mongo)
    db = database.Database(client, cnf_mongo['db'])
    try:
        rc = db.command("createUser", new_user, pwd=pwd, roles=_db_get_roles(cnf, roles))
        logging.info('createUser {}   {}/{}/{}'.format(rc, new_user, pwd, roles))
    except Exception as e:
        logging.getLogger(__name__).exception(e)


def db_change_user(cnf, user, pwd):
    logging.getLogger(__name__).info('Change user: {}'.format(user))
    cnf_mongo = cnf['mongoDB']
    client = db_get_client(cnf_mongo)
    db = database.Database(client, cnf_mongo['db'])
    try:
        rc = db.command("updateUser", user, pwd=pwd)
        logging.info('updateUser {}   {}/{}'.format(rc, user, pwd))
    except Exception as e:
        logging.getLogger(__name__).exception(e)
        raise e


def db_delete_user(cnf, userid):
    logging.getLogger(__name__).info('Drop user: {}'.format(userid))
    cnf_mongo = cnf['mongoDB']
    client = db_get_client(cnf_mongo)
    db = database.Database(client, cnf_mongo['db'])
    try:
        db.command("dropUser", userid)
    except Exception as e:
        logging.getLogger(__name__).info(e)


def db_is_valid_user(cnf, user_id):
    cnf_mongo = cnf['mongoDB']
    client = db_get_client(cnf_mongo)
    db = database.Database(client, cnf_mongo['db'])
    try:
        users = db.command("usersInfo")
        for u in users['users']:
            if user_id == u['user']:
                return True
    except Exception as e:
        logging.getLogger(__name__).exception(e)
    return False


def db_reset_pwd_as_db(cnf, user_id, pwd):
    cnf_mongo = cnf['mongoDB']
    client = db_get_client(cnf_mongo)
    db = database.Database(client, cnf_mongo['db'])
    try:
        rc = db.command("updateUser", user_id, pwd=pwd)
        logging.info('updateUser {}   {}/{}'.format(rc, user_id, pwd))
    except Exception as e:
        logging.getLogger(__name__).exception(e)
        raise e


def db_set_roles(cnf, userid, roles):
    if not roles or len(roles) == 0:
        return
    dbroles = ['userAdmin', 'rwUser'] if 'admin' in roles else ['rwUser']
    logging.getLogger(__name__).info('Set Roles user: {}'.format(userid))
    cnf_mongo = cnf['mongoDB']
    client = db_get_client(cnf_mongo)
    db = database.Database(client, cnf_mongo['db'])
    try:
        rc = db.command("updateUser", userid, roles=dbroles)
        logging.info('updateUser {}   {}/{}'.format(rc, userid, roles))
    except Exception as e:
        logging.getLogger(__name__).exception(e)


def _db_get_roles(cnf, roles):
    ret = [cnf['auth']['roleRWUser']]
    if 'admin' in roles:
        ret.append(cnf['auth']['roleUseranager'])
    return ret
