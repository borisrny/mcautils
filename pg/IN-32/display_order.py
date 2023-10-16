#!/usr/bin/env python
statuses_display_order = [
	'- READY FOR FUNDING',
	'Funded',
	'Funded NA',
	'Funded Edit',
	'Funded Other',
	'A.N.F. (Approved - Not - Funded)',
	'Contract IN',
	'Contract IN (Samin)',
	'Contract IN (Pelin)',
	'Contract IN (Olya)',
	'Ready for pricing',
	'Possible Decline',
	'Pricing (Alla S)',
	'Pricing (Alex S)',
	'Pricing (Alex P)',
	'Pricing (Vika B)',
	'Ready for Calc',

	'Processing UW (Anna K)',
	'Processing UW (Arsen B)',
	'Processing UW (Bohdan P)',
	'Processing UW (Olga O)',
	'Processing UW (Ana F)',
	'Processing UW (Valeria Q)',
	'Processing UW (Oksana V)',
	'Processing UW (Andrea B)',
	'Processing UW (Anastasiia S)',
	'Processing UW (Daniela C)',
	'Processing UW (Anna Shlepina)',
	'Processing UW (Stanislav Antiukh)',
	'Processing UW (Kostya Voytiv)',
	'Processing UW (Lena T)',

	'New Deals',
	'Data Processing (Iryna L)',
	'Data Processing (Isabella M)',
	'Data Processing (Karol H)',
	'Data Processing (Kristina H)',
	'Data Processing (Mariia S)',
	'Data Processing (Nadiia Y)',
	'Data Processing (Natalia T)',
	'Data Processing (Oleksandr K)',
	'Data Processing (Olena K)',
	'Pre-Approved',
	'Contract OUT',
	'Contract Requested',
	'Declined',
	'',
	'Canceled',
	'CC Pre-Approved',
	'Completed',
	'Merchant Fee',
	'Overpaid',
	'Rescind',
	'Unknown',
	'White Labeling',
	'x - DELETED DEAL - x'
]
from dbutils import pg_get_connection, pg_return_connection, pg_update_cond
from jobs.jobutils import run_app
from jobs.jobutils import setup_common_pars_args



def _process(cnf):
    con = pg_get_connection(cnf['pg'])
    con.autocommit = True

    cur = con.cursor()
    cur.execute('ALTER TABLE mcastatus ADD display_order INT NOT NULL DEFAULT 10000')
    cur.close()

    pg_return_connection(con)

    current_order = 0

    for status in statuses_display_order:
        current_order += 10

        pg_update_cond(cnf, 'mcastatus',
            {'display_order': current_order},
            {'status': status})

    return True


if __name__ == '__main__':
    parser = setup_common_pars_args('Convert core contract to PG')
    args = parser.parse_args()
    run_app(args, 'user2pg', _process)
