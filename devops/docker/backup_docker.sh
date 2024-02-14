container_loc="/opt/docker/razor_notess"
c_backups_loc="${container_loc}/backup"
stg_files_loc="${container_loc}/files"
env_file="${container_loc}/.env"
import ${env_file}

container=db_razor_notes
mysql_user=root
mysql_pass=${DB_ROOT_PASS}
mysql_db=razor_notes
hetz_box=u334992
hetz_user=u334992-sub1

LOGFILE=${c_backups_loc}/razor_db.log
DATE=$(date +%Y-%m-%d_%H:%M)

RZR_PROJECT="Razor Notes"

echo "$(date '+%Y%m%d %T') : Backup the ${RZR_PROJECT} DB" | tee -a ${LOGFILE}
docker container exec -i $container mysqldump --user="${mysql_user}" --password="${mysql_pass}" ${mysql_db} > ${c_backups_loc}/${mysql_db}.sql 2>> $LOGFILE

if [ $? -eq 0 ]; then
    echo "Backup of the database successfull" | tee -a ${LOGFILE}
    mkdir -p ${c_backups_loc}/old
    find ${c_backups_loc}/old -mtime 10 -name "*.sql" -delete
    cp ${c_backups_loc}/${mysql_db}.sql ${c_backups_loc}/old/${mysql_db}_${DATE}.sql 2>> ${LOGFILE}
    /usr/bin/rsync -ahv -e 'ssh -p23' ${container_loc}/${mysql_db}.sql ${hetzner_user}@${hetz_box}.your-storagebox.de:database/klr_simul.sql
    /usr/bin/rsync -ahv -e 'ssh -p23' ${container_loc}/${mysql_db}.sql ${hetzner_user}@{hetz_box}.your-storagebox.de:database/old/${mysql_db}_${DATE}.sql
    /usr/bin/rsync -ahv -e 'ssh -p23' --delete ${stg_files_loc} ${hetzner_user}@{hetz_box}.your-storagebox.de:stg_files/

else
    echo "Backup of the database Failed" | tee -a ${LOGFILE}
fi
echo "$(date '+%Y%m%d %T') : FINISHED the ${RZR_PROJECT} Backup" | tee -a ${LOGFILE}
