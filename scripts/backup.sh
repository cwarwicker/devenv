#!/bin/sh

# Import the project.sh file to get all the variables.
source $(pwd)'/env/scripts/project.sh'

DAY=$(date +"%A")

# Database Backup Script.
DB_USER=${1:-root}
DB_PASS=${2:-password}
FILE=${3:-"./backups/${PROJECT_NAME}-${DAY}.sql"}
DB="${4:-main}"
CONTAINER="${PROJECT_NAME}-db"

echo "[`date "+%d-%m-%Y %H:%M:%S"`] Initiating backup of [${DB}] to: [${FILE}]"

docker exec -it ${CONTAINER} /usr/bin/mysqldump -u ${DB_USER} -p${DB_PASS} ${DB} > ${FILE}

echo "[`date "+%d-%m-%Y %H:%M:%S"`] Backup complete"