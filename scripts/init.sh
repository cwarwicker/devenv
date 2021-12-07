#!/bin/bash

# Import the project.sh file to get all the variables.
source $(pwd)'/env/scripts/project.sh'

DOCKER_COMPOSE_FILE='docker-compose.yml'

# Wipe the log file and any generated files.
> ${LOG_FILE}
> ${DOCKER_COMPOSE_FILE}

# Begin setup.
echo 'Initialising ('${PROJECT_NAME}') project'

# Copy the docker-compose template and replace values.
cp ${DIR_TEMPLATES}'/docker-compose.yml.template' ${DOCKER_COMPOSE_FILE}

# Replace variables in new docker-compose file.
sed -i -e 's#%project.name%#'${PROJECT_NAME}'#g' ${DOCKER_COMPOSE_FILE}
sed -i -e 's#%project.path%#'${PROJECT_PATH}'#g' ${DOCKER_COMPOSE_FILE}
sed -i -e 's#%project.port%#'${PROJECT_PORT}'#g' ${DOCKER_COMPOSE_FILE}

echo 'Done'
echo 'Please run "./up" to start the project'