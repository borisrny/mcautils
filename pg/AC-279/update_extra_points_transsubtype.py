import os
import logging
import argparse

from dbutils import pg_intarray_to_in, pg_execute
from utils import load_config
from utils import AppConstants, UserConstants
from users import user_special_user

def main(cnf):
    consts = AppConstants(cnf)
    user_const = UserConstants(cnf)
    cf_user_id = user_special_user(cnf, user_const.role_contract_fee, None)

    sql = 'SELECT t.id id1, t2.id id2 ' \
        ' FROM {schema}.transaction t, {schema}.transcrosref r, ' \
        '{schema}.transaction t2' \
        ' WHERE t.transtype={paym_type} ' \
        ' AND t.status in ({paid_status}) ' \
        ' AND t.ammount<0 ' \
        ' AND t.userid={cf_user_id}' \
        ' AND t.transsubtype is NULL ' \
        ' AND r.refid=t.id ' \
        ' AND t2.id=r.transid ' \
        ' AND t2.userid>0 ' \
        ' AND t2.transtype={paym_type} ' \
        ' AND t2.status in ({paid_status}) ' \
        ' AND t2.transsubtype is NULL ' \
        .format(
            schema=cnf['pg']['schema'],
            paid_status=pg_intarray_to_in(consts.agg_transstat_processed),
            paym_type=consts.trans_type_payment,
            cf_user_id=cf_user_id
        )

    uniq = {}
    for i in pg_execute(cnf, sql):
        uniq[i['id1']] = True
        uniq[i['id2']] = True

    for trans_id in uniq.keys():
        sql_update = 'UPDATE {schema}.transaction SET transsubtype={subtype} WHERE id={id} AND transsubtype is null RETURNING id ' \
            .format(
                schema=cnf['pg']['schema'],
                subtype=consts.trans_sub_type_cf_extra_points,
                id=trans_id
            )

        pg_execute(cnf, sql_update)

    return True

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser(description='Set subtype extra points transactions')
    parser.add_argument("--config", "-c", required=True, help="Config file relative path")
    args = parser.parse_args()
    abs_config_path = os.path.abspath(args.config)
    config_dir = os.path.dirname(abs_config_path)
    root_dir = os.path.split(config_dir)[0]
    current_dir = os.getcwd()
    os.chdir(root_dir)
    cnf = load_config(abs_config_path)
    os.chdir(current_dir)

    main(cnf)
