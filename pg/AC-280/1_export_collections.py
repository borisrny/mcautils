import argparse
import csv
import logging
import os

from flask.ctx import AppContext

from dbutils import get_mongo_collection
from utils import load_config


def export_collection(cnf, cname, ofd):
    coll = get_mongo_collection(cnf, cname)

    doc_fields = {
        "rateTermMap": ["_id", "count", "factorRate", "term"],
        "business_types": ["_id", "name"],
        "ownertitle": ["_id", "title"],
    }

    if cname not in doc_fields:
        logging.error("No mapping found for collection {0}".format(cname))
        return

    fields = doc_fields[cname]
    total_docs = 0

    csv_writer = csv.DictWriter(ofd, fieldnames=fields)
    csv_writer.writeheader()

    for doc in coll.find():
        total_docs += 1
        _id = doc.get('_id')
        extra_keys = list(set(doc.keys())-set(fields))
        if len(extra_keys) > 0:
            logging.warning("Extra keys were found in collection {0}: {1}", cname, extra_keys)
        csv_writer.writerow(doc)

    logging.info("DB: {0}   |   Collection: {1:<20} |   Total docs: {2}".format(cnf['mongoDB']['db'], cnf['mongoDB'][cname], total_docs))


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser(description='Assign unique id for owners in mca collection')
    parser.add_argument("--config", "-c", required=True, help="Config file relative path")
    parser.add_argument("--mongo-username", "-u", required=True, help="MongoDB username")
    parser.add_argument("--mongo-password", "-p", required=True, help="MongoDB password")
    parser.add_argument("--collections", default="rateTermMap,ownertitle,business_types", help="Collection names from mongo.yaml to export separated by comma.")
    args = parser.parse_args()
    abs_config_path = os.path.abspath(args.config)
    config_dir = os.path.dirname(abs_config_path)
    root_dir = os.path.split(config_dir)[0]
    current_dir = os.getcwd()
    os.chdir(root_dir)
    config = load_config(abs_config_path)
    os.chdir(current_dir)
    AppContext().set_login_credentials(args.mongo_username, args.mongo_password)
    files = []
    for collection_name in args.collections.split(','):
        output_file_name = "{0}.csv".format(collection_name)
        with open(output_file_name, 'w') as fd:
            export_collection(config, collection_name, fd)
            files.append(output_file_name)

    logging.info("Saved to files: {0}".format(files))
