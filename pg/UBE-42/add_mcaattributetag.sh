#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO mcaattributestag(name)
    SELECT 'isorel_comp_notif'
    WHERE NOT EXISTS (
        SELECT id FROM mcaattributestag
        WHERE name='isorel_comp_notif'
    );
"

pg_execute "INSERT INTO emlconfig(tag, name, sender, reply_to, cc, bcc)
    SELECT 'isorel_competition_notif', 'ISO Relation competition notification', 'Underwriting@globalfundingexperts.com', 'Underwriting@globalfundingexperts.com', '{}', '{}'
    WHERE NOT EXISTS (
        SELECT tag FROM emlconfig
        WHERE tag='isorel_competition_notif'
    )
"
