#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"


TABLE="system_config"

pg_execute "
DROP TABLE IF EXISTS %SCHEMA%.${TABLE};
"

pg_execute "
CREATE TABLE IF NOT EXISTS %SCHEMA%.${TABLE}
(
    id SERIAL NOT NULL PRIMARY KEY,
    tag CHARACTER VARYING NOT NULL,
    value CHARACTER VARYING NOT NULL
);"

pg_execute "INSERT INTO %SCHEMA%.${TABLE} (tag, value) VALUES ('defaultVenue', '38');"
pg_execute "INSERT INTO %SCHEMA%.${TABLE} (tag, value) VALUES ('minDepositToMerchantAmount', '100');"
pg_execute "INSERT INTO %SCHEMA%.${TABLE} (tag, value) VALUES ('minDepositLastToMerchantAmount', '100');"
pg_execute "INSERT INTO %SCHEMA%.${TABLE} (tag, value) VALUES ('minLastPaymentAmount', '10');"
pg_execute "INSERT INTO %SCHEMA%.${TABLE} (tag, value) VALUES ('sameDayAchTimeThreshold', '50400000');"
pg_execute "INSERT INTO %SCHEMA%.${TABLE} (tag, value) VALUES ('nextDayAchTimeThreshold', '63900000');"
