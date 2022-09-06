#!/bin/bash

CONTAINER_ALREADY_STARTED=/home/entrypoints/var/CONTAINER_ALREADY_STARTED
export ENTRYPOINT_PATH=/home/entrypoints

if [ ! -e $CONTAINER_ALREADY_STARTED ]
then
  . ${ENTRYPOINT_PATH}/src/workdir-generator.sh
  . ${ENTRYPOINT_PATH}/src/apache-configurator.sh ${DEFAULT_WORK_DIR}
  . ${ENTRYPOINT_PATH}/src/git-project-extractor.sh ${PROJECT_REPOSITORY_URL}
  . ${ENTRYPOINT_PATH}/src/db-creator.sh

  touch $CONTAINER_ALREADY_STARTED
  cat ${ENTRYPOINT_PATH}/logs/setup.log

  . ${ENTRYPOINT_PATH}/src/init-prestashop.sh

  echo '[🎉] - The End Game'
fi

