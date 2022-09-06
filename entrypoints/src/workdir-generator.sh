#!/bin/bash

logs_file=${ENTRYPOINT_PATH}/logs/setup.log

DEFAULT_PROJECT_NAME=$(date +%F%H%M%S)

if [ "$PROJECT_NAME" != "<to be defined>" ] && [ ! -z "$PROJECT_NAME" ]; then
    PROJECT_NAME_PURIFIED=$(echo $PROJECT_NAME | sed -e 's/[^A-Za-z0-9._-]/_/g')
    DEFAULT_PROJECT_NAME=$PROJECT_NAME_PURIFIED
else
   echo "[⚠️] - Le nom du project non défini. Le nom par défaut est : $DEFAULT_PROJECT_NAME"
fi

export DEFAULT_WORK_DIR="/var/www/html/${DEFAULT_PROJECT_NAME}"
mkdir -p $DEFAULT_WORK_DIR

if [ $? -ne 0 ]; then
    echo "[❌] - Erreur lors de la création de l'espace de travail par défaut : $DEFAULT_WORK_DIR" 
else
    echo "[✅] - Création de l'espace de travail par défaut : $DEFAULT_WORK_DIR " 
    workdir_alias=/home/application/${DEFAULT_CLIENT_NAME}/
    mkdir -p $workdir_alias
    ln -s $DEFAULT_WORK_DIR $workdir_alias
fi

