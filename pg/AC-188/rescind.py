#!/usr/bin/env python

from jobs.jobutils import setup_common_pars_args, run_app
from mcahelpers import mca_get_by_status, mcaposition_save_rescind_rate
from utils import McaConstants


def _process(cnf):
    mca_consts = McaConstants(cnf)
    mca_list = mca_get_by_status(cnf, mca_consts.mca_status_rescind,
                                 ['position'])

    for mca in mca_list:
        mcaposition_save_rescind_rate(cnf, mca['id'])

    return True


if __name__ == '__main__':
    parser = setup_common_pars_args('Add rescind rate')
    args = parser.parse_args()
    run_app(args, 'investors2pg', _process)
