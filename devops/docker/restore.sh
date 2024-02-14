#!/usr/bin/env bash

# script downloads latest database from storage, and uploadds it into mysql
# also copies images/data and places them into the containers folders

container_loc="/home/user/docker/appname/"
backupppp_loc="${container_loc}backup/"
productss_loc="${container_loc}images/development/products/"
container=<container_name>
mysql_user=<mysql_user>
mysql_pass=<myslq_password>
mysql_db=<mysql_database_name>
hetzner_user=<hetzner_user>
LOGFILE=restore.log
DATE=$(date +%Y-%m-%d_%H:%M)

cd $backupppp_loc


echo "$(date '+%Y%m%d %T') : Starting Restore" >> ${LOGFILE}
echo "$(date '+%Y%m%d %T') : Starting Restore"
/usr/bin/rsync -ahv -e 'ssh -p23' ${hetzner_user}@hetzner_main_user.your-storagebox.de:database/${mysql_db}.sql ${backupppp_loc}${mysql_db}.sql

if [ $? -eq 0 ]; then
    echo "Database successfully retrieved"
    echo "Database successfully retrieved" >> ${LOGFILE}
    mkdir -p ${backupppp_loc}/old
    cp ${mysql_db}.sql ${backupppp_loc}old/${mysql_db}_${DATE}.sql 2>> $LOGFILE
    find ${backupppp_loc}old -mtime 10 -name "*.sql" -delete
    /usr/bin/docker exec -i $container mysql --user="$mysql_user" --password="$mysql_pass" $mysql_db < ${mysql_db}.sql 2>> ${LOGFILE}
    #restore images from hetzner
    /usr/bin/rsync -ahv -e 'ssh -p23' --delete ${hetzner_user}@hetzner_main_user.your-storagebox.de:images/development/products/ ${productss_loc}
else
    echo "Retrieving of the database Failed" >> ${LOGFILE}
fi
