#!/bin/bash

####### DO NOT CALL THIS SCRIPT DIRECTLY. IT SHOULD ONLY BE INCLUDED BY THE init SCRIPT IN THE PROJECT REPO #######

DIR=$(pwd)
DIR_LOGS=${DIR}'/logs'
DIR_TEMPLATES=${DIR}'/templates'

# Try to load the project environment file.
if [ ! -f ${DIR}'/project.json' ]; then
  echo 'Please create project.json environment file then try again.'
  exit 1
fi

# Get environment info.
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
PROJECT_ENV=${DIR}'/project.json'
LOG_FILE=${DIR_LOGS}'/provision.txt'

# Get project info.
PROJECT_NAME=$(jq -r '.name' ${PROJECT_ENV})
PROJECT_REPO=$(jq -r '.repo' ${PROJECT_ENV})
PROJECT_BRANCH=$(jq -r '.branch' ${PROJECT_ENV})
PROJECT_PATH=$(jq -r '.path' ${PROJECT_ENV})
PROJECT_MODULES=$(jq -r '.submodules' ${PROJECT_ENV})
PROJECT_DOMAIN=$(jq -r '.domain' ${PROJECT_ENV})
PROJECT_SITE_ADDRESS=${PROJECT_NAME}'.'${HOSTNAME}${PROJECT_DOMAIN}