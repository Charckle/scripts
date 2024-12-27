#!/usr/bin/env bash

source ../.env

container_name="db_razor_notes"
root_db_pass=${DB_ROOT_PASS}
db_name=${DB_NAME}

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 It takes one argument, database file to restore"
    exit 1
fi

# Access the first argument using $1
db_to_restore=$1

docker exec -i ${container_name} mysql --user='root' --password=${root_db_pass} ${db_name} ${humhub} < ${db_to_restore}
