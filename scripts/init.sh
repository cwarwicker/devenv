#!/bin/bash

# Import the project.sh file to get all the variables.
source $(pwd)'/env/scripts/project.sh'

# Wipe the log file.
> ${LOG_FILE}

# Begin setup.
echo 'Initialising ('${PROJECT_NAME}') project'

# Find all the template files specified for this project.
for FILE in ${DIR_TEMPLATES}/*.template; do

  # Check the name of the file, to see if it has a specific hard-coded location.
  FILE_NAME=$(basename -- $FILE)

  # Moodle-specific templates.
  if [ ${FILE_NAME} = 'moodle.config.php.template' ]
    then

      # Override file name.
      FILE_NAME=${PROJECT_PATH}'config.php'

  else

      # Otherwise, assume it just goes in the top level.
      # Remove ".template" from the end of the file name.
      FILE_NAME=${FILE_NAME%.template}

  fi

  # Copy the file.
  cp "${FILE}" "${FILE_NAME}"

  # Replace variables in new docker-compose file.
  sed -i -e 's#%project.type%#'${PROJECT_TYPE}'#g' ${FILE_NAME}
  sed -i -e 's#%project.name%#'${PROJECT_NAME}'#g' ${FILE_NAME}
  sed -i -e 's#%project.path%#'${PROJECT_PATH}'#g' ${FILE_NAME}
  sed -i -e 's#%project.port%#'${PROJECT_PORT}'#g' ${FILE_NAME}
  sed -i -e 's#%project.url%#'${PROJECT_URL}'#g' ${FILE_NAME}

done

echo 'Completed'
echo 'Please run `./up` to start the project'