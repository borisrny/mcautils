#!/bin/bash

set -e

PG_ENV="$1"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_PATH/../pg_util.bash"

pg_execute "INSERT INTO mcastatus (status, category, property_name, display_order)
SELECT 'Processing Calc', 'Final Underwriting Department', 'mca_status_processing_calc', 10000
WHERE NOT EXISTS (SELECT status FROM mcastatus WHERE property_name='mca_status_processing_calc')"
