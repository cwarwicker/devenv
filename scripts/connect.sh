#!/bin/bash

# Require the project.sh so we can get the name of the web container.
source $(pwd)'/env/scripts/project.sh'

DEFAULT_CONTAINER=${PROJECT_NAME}'-'${PROJECT_TYPE}
CONTAINER_NAME=${1:-$DEFAULT_CONTAINER}

docker exec -it ${CONTAINER_NAME} bash