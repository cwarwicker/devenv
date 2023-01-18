#!/bin/sh

# Import the project.sh file to get all the variables.
source $(pwd)'/env/scripts/project.sh'

# Load the DB_* variables from .env file of project.
set -o allexport
source $(pwd)'/code/.env'
set +o allexport

DAY=$(date +"%A")
FILE=${1:-"./backups/${PROJECT_NAME}-${DAY}.sql"}
CONTAINER="${PROJECT_NAME}-db"

echo "[`date "+%d-%m-%Y %H:%M:%S"`] Initiating backup of [${DB_NAME}] to: [${FILE}]"
docker exec -it ${CONTAINER} /usr/bin/mysqldump -u ${DB_USER} -p${DB_PASS} ${DB_NAME} > ${FILE}
echo "[`date "+%d-%m-%Y %H:%M:%S"`] Backup complete"