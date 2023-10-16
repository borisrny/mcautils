import csv
from collections import defaultdict

root = '/Users/boris/PycharmProjects/gfe/pg/scripts'

trans_f = 'RTR-BALANCE-GFE.csv'
inv_f = 'INVESTORS.csv'
result_f = 'combined.csv'

investors = defaultdict(list)
rtrs = {}

fn = '/'.join((root, inv_f))
print(fn)
with open(fn) as f:
    reader = csv.DictReader(f, delimiter=',')
    for row in reader:
        investors[int(row['mcaid'])].append(row)

fn = '/'.join((root, trans_f))
print(fn)
with open(fn) as f:
    reader = csv.DictReader(f, delimiter=',')
    for row in reader:
        print('row: {}'.format(row))
        rtrs[int(row['mcaid'])] = round(float(row['RTR-B-35']), 2)

# with open(result_f, 'w') as csvfile:
#     writer = csv.DictWriter(csvfile, fieldnames=deals[0].keys())
#     writer.writeheader()
#     for data in deals:
#         writer.writerow(data)


res = []
for k, v in rtrs.items():
    inv = investors[k]
    for r in inv:
        print('mca: {}, expected: {}, First NAme: {}, Last Name: {}'.format(
            k, round(v * float(r['part']), 2),
            r['firstname'], r['lastname'])
        )
        res.append({
            'mca:': k,
            'RTR Balance': round(v * float(r['part'])/100, 2),
            'First Name': r['firstname'],
            'Last Name': r['lastname'],
        })

with open(result_f, 'w') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=res[0].keys())
    writer.writeheader()
    for data in res:
        writer.writerow(data)
