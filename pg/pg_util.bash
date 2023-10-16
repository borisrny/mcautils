SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $PG_ENV = "prod" ]]; then
    CONFIG_FILE="$SCRIPT_PATH/../config/config_aws.yaml"
elif [[ $PG_ENV = "uat" ]]; then
    CONFIG_FILE="$SCRIPT_PATH/../config/aws_uat2_conf.yaml"
elif [[ $PG_ENV = "local" ]]; then
    CONFIG_FILE="$SCRIPT_PATH/../config/site.yaml"
else
    echo "Error: environment name is required (local/uat/prod)"
    exit
fi

echo "Getting postgres configs from $CONFIG_FILE"

function pg_param {
    egrep -A7  "^pg:" "$CONFIG_FILE" | grep "$1:" | awk -F ':' '{print $2}' | sed 's/^[ ]*//'
}

function pg_load_config {
    USER=$(pg_param 'user')
    PASSWD=$(pg_param 'pwd')
    DB=$(pg_param 'db')
    HOST=$(pg_param 'host')
    SCHEMA=$(pg_param 'schema')

    if [[ $PG_ENV = "uat" ]]; then
        OWNER=""
    else
        OWNER="$USER"
    fi
}

function pg_execute {
    SQL=$(echo "$1" | sed "s/%SCHEMA%/$SCHEMA/g" | sed "s/%OWNER%/$OWNER/")

    echo "SQL: $SQL"

    PGPASSWORD=${PASSWD}  psql -h ${HOST} -U ${USER} -d ${DB} -c "${SQL}"
}

function pg_create_custom_type {
    NAME="$1"
    SQL="$2"

    pg_execute "
    DO "'$$'"
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='$NAME') THEN
            $SQL
        END IF;
    END "'$$'";"
}

pg_load_config

echo "USER=$USER"
echo "DB=$DB"
echo "HOST=$HOST"
echo "SCHEMA=$SCHEMA"
echo "ENV: $PG_ENV"
