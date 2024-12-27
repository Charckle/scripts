#!/usr/bin/env bash

source ../.env

#container_loc="/home/andrejz/docker/razornotes/backups"

container_name="db_razor_notes"
root_db_pass=${DB_ROOT_PASS}
db_name=${DB_NAME}

archive_folder="old_manual"

docker exec -i ${container_name} mysqldump --user='root' --password=${root_db_pass} ${db_name} > ${db_name}_$(date +%Y-%m-%d).sql

if [ $? -eq 0 ]; then
        echo "Backup of the database successfull"
        mkdir -p ${archive_folder}
        find ${archive_folder} -mtime +10 -name "*.sql" -delete
        cp ${db_name}.sql ${archive_folder}/${db_name}_${DATE}.sql
else
        echo "Backup of the database Failed"
fi
