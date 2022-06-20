#!/bin/bash

# Import the project.sh file to get all the variables.
source $(pwd)'/env/scripts/project.sh'

DOCKER_COMPOSE_FILE='docker-compose.yml'
EXISTS=false
FLAG="${1}"

# Make sure the project has been initialised.
if [[ ! -f "${DOCKER_COMPOSE_FILE}" ]]; then
  echo 'Project has not been initialised. Please run `./init` then try again.'
  exit 1
fi

# Wipe existing log file.
> ${LOG_FILE}

echo 'Setting up ('${PROJECT_NAME}') development environment'

# Firstly clone down the main repo into the specified path. Unless it has already been cloned.
if [[ ! -d ${PROJECT_PATH} ]]
then
  echo 'Attempting to clone' ${PROJECT_REPO} 'into' ${PROJECT_PATH}'...'
  git clone --progress -b ${PROJECT_BRANCH} ${PROJECT_REPO} ${PROJECT_PATH} 2>> ${LOG_FILE}
else
  echo 'Project repository already cloned. Moving on...'
  EXISTS=true
fi

# Move into the code directory.
cd ${PROJECT_PATH}

# Update any submodules which already exist in the repo. Only if this is the first time.
if [ "${EXISTS}" = false ]
then
  echo 'Updating repository submodules...'
  git submodule update --recursive --init 2>>${LOG_FILE}
fi

# Now add any extra submodule as defined in the env file.
echo 'Updating core submodules from' ${PROJECT_ENV} 'file...'

## This works by firstly using the content of PROJECT_MODULES which is the array of json objects from project.env. This is
## passed into the jq function. Next we get the keys of the array. This would normally return an array of keys, but then we pipe
## that into '.[]' which gets each individual one. So, if printed, the result of that would be the numeric keys, printed each on a
## new line. That key is what goes into the $key variable and from there we can use the keys to get each individual array element
## and then the properties on them.
for key in $(jq 'keys | .[]' <<< ${PROJECT_MODULES}); do

  submodule=$(jq -r ".submodules[${key}]" ${PROJECT_ENV})
  submodule_repo=$(jq -r '.repo' <<< ${submodule})
  submodule_branch=$(jq -r '.branch' <<< ${submodule})
  submodule_path=$(jq -r '.path' <<< ${submodule})

  # If it already exists, skip it as we don't want to override it.
  clone_path=${DIR}/${PROJECT_PATH}$submodule_path

  if [[ ! -d ${clone_path} ]]
    then
        echo 'Adding submodule:' ${clone_path}' from' ${submodule_repo} '('${submodule_branch}')...'
        # We force the submodule add, as the ./code directory is ignored and otherwise it will refuse.
        git submodule add -f -b ${submodule_branch} ${submodule_repo} ${submodule_path} 2>>${LOG_FILE}
  else
        echo 'Skipping' ${submodule_path} 'as it already exists...'
  fi

done

echo 'Setup finished.'
echo '=============='

# Now start the docker containers.
cd ${DIR}

# If we need to rebuild the image, call `./up rebuild`.
if [[ "${FLAG}" = "rebuild" ]]
then
  docker-compose build --no-cache
fi

docker-compose up -d
cd ${DIR}

if [[ "${PROJECT_TYPE}" = "web" ]]
then
  echo '=============='
  echo 'Site will be rendered at: http://'${PROJECT_SITE_ADDRESS}:${PROJECT_PORT}
  echo 'Please add the following to your hosts file:' ${IP}'    '${PROJECT_SITE_ADDRESS}
  echo '=============='
fi

echo 'See:' ${LOG_FILE} 'for output...'