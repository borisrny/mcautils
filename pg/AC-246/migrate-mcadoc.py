"""
This script is used to make migration of mcadoc collection from MongoDB to postgres database. It requires python >= 3.7 and psycopg2 package

Migration steps
---------------
1. Export userid and username from gfeny.login table.
    psql -h <<PGHOST>> -U <<PGUSER>> <<PGDB>> -c "copy gfeny.login(personid,userid) TO '/tmp/login.csv' DELIMITER ',' CSV;"
    OR
    psql -h <<PGHOST>> -U <<PGUSER>> <<PGDB>> --csv --tuples-only -c "SELECT personid, userid FROM gfeny.login" > /tmp/login.csv

2. Export mcadoc collection to json file:
    mongoexport -u <<USER>> --authenticationDatabase <<AUTHDB>> --db <<DB>> --collection mcadoc --out /tmp/mcadoc.json

3. Create mcadoc table in Postgres (gfeny schema). Run pg/AC-246/createtable.bash script

4. Run this script:
    python migrate-mcadoc.py --schema gfeny /tmp/mcadoc.json /tmp/login.csv /tmp/mcadoc.csv 2>&1 | tee export.log

    - data will be saved to /tmp/mcadoc.csv
    - Export logs will be displayed on the screen and saved to export.log
    - Check any records in log which start with 'ERROR:root:SKIPPED'. They will not be migrated to Postgres
    - Last line in log shows statistic

5. Run in Postgres (you can copy these commands from end of log file):
    COPY gfeny.mcadoc FROM '/tmp/mcadoc.csv' WITH CSV HEADER;
    SELECT setval('{schema}.mcadoc_id_seq', (SELECT MAX(id) FROM {schema}.mcadoc));
"""

import argparse
import csv
from datetime import datetime
import json
import logging

FIELDS_TO_EXPORT = {
        '_id': 'id',
        'create_timestamp_': 'create_timestamp',
        'description': 'description',
        'filename': 'filename',
        'create_userid': 'create_userid',
        'mcaid': 'mcaid',
        'category': 'categoryid',
}

DB_FIELDS = ['id', 'mcaid', 'create_userid', 'categoryid', 'create_timestamp', 'filename', 'description' ]

def load_users(fd):
    users = {}
    csvreader = csv.reader(fd)
    for row in csvreader:
        (userid, name) = row
        if name in users:
            logging.warning(f"{name} is appeared more than once. Doc for this user will not be migrated")
            continue
        users[name] = int(userid)

    return users

def parse_ts(ts, fmt):
    try:
        dt = datetime.strptime(ts, fmt)
        return dt, None
    except ValueError as e:
        return None, str(e)

def generate_queries(schema, output, mcadoc, users):
    writer = csv.DictWriter(output, fieldnames=DB_FIELDS)
    writer.writeheader()

    total = total_imported = total_skipped = 0
    for row in mcadoc:
        doc = json.loads(row)
        total += 1
        create_userid = None
        create_user = doc.get('create_user', 0)
        if type(create_user) == int:
            if create_user in users.values():
                doc['create_userid'] = create_user
            else:
                doc['create_userid'] = 0
                logging.warning(f"{doc['_id']} / {doc['mcaid']} | create_user={create_user} and this value does not exist in {schema}.login.loginid Set to 0")
        elif type(create_user) == str:
            if create_user.isnumeric():
                logging.warning(f"{doc['_id']} / {doc['mcaid']} | create_user={create_user}. It has type string but numeric. Will convert it to numeric")
                create_user = int(create_user)
                if create_user in users.values():
                    doc['create_userid'] = create_user
                else:
                    doc['create_userid'] = 0
                    logging.warning(f"{doc['_id']} / {doc['mcaid']} | create_user={create_user} and this value does not exist in {schema}.login.loginid Set to 0")
            else:
                if create_user in users:
                    doc['create_userid'] = users[create_user]
                else:
                    doc['create_userid'] = 0
                    logging.warning(f"{doc['_id']} / {doc['mcaid']} | create_user={create_user} and this value does not exist in {schema}.login.loginid Set to 0")
        else:
            logging.error(f"SKIPPED {doc['_id']} / {doc['mcaid']} | Reason: create_user={create_user} and this type neither str nor int")
            total_skipped += 1
            continue

        if 'create_timestamp' in doc:
            ts = doc['create_timestamp']
            ts_val = None
            if type(ts) == str:
                ts_val = ts
            elif type(ts) == dict:
                ts_val = ts.get('$date', None)
                if ts_val is None:
                    logging.error(f"SKIPPED {doc['_id']} / {doc['mcaid']} | Reason: unable to find $date key in {ts} dict")
                    total_skipped += 1
                    continue
                ts_val = ts_val.rstrip('Z')
                # datetime.fromisoformat accepts string in format 'YYYY-MM-DD[*HH[:MM[:SS[.fff[fff]]]][+HH:MM[:SS[.ffffff]]]]'
                # We have YYYY-MM-DDTHH:MM:SS.fff but for some records there are 1 or 2 digits for microseconds and datetime.fromisoformat fails
                # So need to add extra zeroes to the end. Don't add them if no ms (no dot)
                if '.' in ts_val:
                    ts_val = ts_val.ljust(len('YYYY-MM-DDTHH:MM:SS.fff'), '0')
            else:
                logging.error(f"SKIPPED {doc['_id']} / {doc['mcaid']} | Reason: no create_timestamp found")
                total_skipped += 1
                continue

            # Thu, 24 Oct 2019 15:38:13 GMT
            # 2019-07-23T13:24:20.027Z   (without Z)
            # 2020-05-18T17:56:48.374+0000
            fmts = ['%a, %d %b %Y %H:%M:%S %Z', '%Y-%m-%dT%H:%M:%S', '%Y-%m-%dT%H:%M:%S.%f', '%Y-%m-%dT%H:%M:%S.%f%z']
            for fmt in fmts:
                (dt, err) = parse_ts(ts_val, fmt)
                if dt is not None:
                    doc['create_timestamp_'] = dt.isoformat()
                    break
            if dt is None:
                logging.error(f"SKIPPED {doc['_id']} / {doc['mcaid']} | Unable to parse ts: {ts_val}")
                total_skipped += 1
                continue

        if 'category' in doc and doc['category'] == 0:
            del doc['category']
            
        values_to_insert = {}
        for field, value in doc.items():
            if field in FIELDS_TO_EXPORT:
                db_field = FIELDS_TO_EXPORT[field]
                values_to_insert[db_field] = str(value)
        writer.writerow(values_to_insert)

        total_imported += 1

    logging.info("COPY {0}.mcadoc ({1}) FROM 'mcadoc.csv' WITH CSV HEADER;".format(schema, ','.join(DB_FIELDS)))
    logging.info(f"SELECT setval('{schema}.mcadoc_id_seq', (SELECT MAX(id) FROM {schema}.mcadoc));")
    return total, total_imported, total_skipped

if __name__ == '__main__':
    import sys
    assert sys.version_info >= (3, 7)
    logging.basicConfig(level=logging.INFO, format="%(asctime)-15s %(levelname)s: %(message)s")
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("--schema", default="gfeny", help="Postgres schema")
    parser.add_argument("mcadoc", type=argparse.FileType("r"), help="Exported mcadoc in json format")
    parser.add_argument("login", type=argparse.FileType("r"), help="CSV file which has 2 columns from Postgres: login.loginid and login.userid")
    parser.add_argument("output", type=argparse.FileType("w"), help="Output file for saving SQL insert queries")

    args = parser.parse_args()

    users = load_users(args.login)
    (total, total_imported, total_skipped) = generate_queries(args.schema, args.output, args.mcadoc, users)
    logging.info(f"Total records: {total}; Ready to insert {total_imported}; Skipped: {total_skipped}")

