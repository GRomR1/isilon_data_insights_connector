#!/usr/bin/env bash

set -o pipefail

COMMAND=${1}

echo CONFIG_FILE_PATH=$CONFIG_FILE_PATH
echo CONFIG_FILE_PATH=$COMMAND
echo Will run \"./isi_data_insights_d.py --config-file $CONFIG_FILE_PATH $COMMAND\"

./isi_data_insights_d.py --config-file $CONFIG_FILE_PATH $COMMAND