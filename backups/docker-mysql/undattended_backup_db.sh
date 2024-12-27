#!/usr/bin/env bash

container_loc="/home/andrejz/docker/razornotes"
c_backups_loc="${container_loc}/backups"

env_file="${container_loc}/.env"
source ${env_file}

container_name="db_razor_notes"
root_db_pass=${DB_ROOT_PASS}
db_name=${DB_NAME}

archive_folder="${c_backups_loc}/old_unattended"

LOGFILE=${c_backups_loc}/razor_db.log
DATE=$(date +%Y-%m-%d_%T)


RZR_PROJECT="Razor Notes"
echo "$(date '+%Y%m%d %T') : Backup the ${RZR_PROJECT} DB" | tee -a ${LOGFILE}

#docker exec -i ${container_name} mysqldump --user='root' --password=${root_db_pass} ${db_name} > ${db_name}_$(date +%Y-%m-%d).sql
docker container exec -i $container_name mysqldump --user='root' --password="${root_db_pass}" ${db_name} > ${c_backups_loc}/${db_name}.sql 2>> $LOGFILE

if [ $? -eq 0 ]; then
    echo "Backup of the database successfull" | tee -a ${LOGFILE}
    mkdir -p ${archive_folder}
    find ${archive_folder} -mtime +10 -name "*.sql" -delete
    cp ${c_backups_loc}/${db_name}.sql ${archive_folder}/${db_name}_${DATE}.sql 2>> ${LOGFILE}
else
    echo "Backup of the database Failed" | tee -a ${LOGFILE}
fi
echo "$(date '+%Y%m%d %T') : FINISHED the ${RZR_PROJECT} Backup" | tee -a ${LOGFILE}
