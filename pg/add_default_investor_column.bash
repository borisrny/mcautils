#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/pg_util.bash"

pg_execute "ALTER TABLE %SCHEMA%.userdefaults ADD COLUMN IF NOT EXISTS default_investor boolean DEFAULT false NOT NULL"
