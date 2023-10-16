import psycopg2

from pymongo import MongoClient

PG_DB = "gfeny"
PG_USER = "postgres"
PG_PASSWORDD = "temp123"
PG_HOST = "localhost"
PG_PORT = 5432

MONGO_HOST = 'localhost'
MONGO_PORT = 27017


def migrate_data():
    client = MongoClient(
        MONGO_HOST,
        MONGO_PORT)

    db = client['mongo_db']
    holidays = db['holidays']

    values_to_insert = [{'date': holiday['date'], 'country': holiday['country']} for holiday in holidays.find()]

    sql = 'INSERT INTO public.holidays (date,country) VALUES (%(date)s, %(country)s)'

    conn = psycopg2.connect(
        database=PG_DB,
        user=PG_USER,
        password=PG_PASSWORDD,
        host=PG_HOST,
        port=PG_PORT)
    cur = conn.cursor()

    cur.executemany(sql, values_to_insert)

    conn.commit()
    conn.close()


if __name__ == '__main__':
    migrate_data()
