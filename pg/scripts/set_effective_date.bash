cat ./tr.csv | awk  '{ print "PGPASSWORD=${PASSWD} psql -h ${HOST} -U ${USER} -d ${DB} -c \"update gfeny\.transaction set effectivedate=\x27" $2 "\x27 where id=" $1 "\"" }'
