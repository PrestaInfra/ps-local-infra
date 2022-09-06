#!/bin/bash

git_repository=$1
tmp_path=${ENTRYPOINT_PATH}/tmp/tmp_repository_clone
logs_file=${ENTRYPOINT_PATH}/logs/setup.log

if [ -z $git_repository ] || [ "${git_repository}" = "<to be defined>" ]
then
    echo "[⚠️]  - Initialization projet vide." 
else
    # Test git repository url
    git ls-remote -q $git_repository &> /dev/null
    if [ $? -ne 0 ]
    then
        echo "[❌] - Impossible de lire le dépôt distant ${git_repository}.Veuillez vérifier que vous avez les droits d'accès et que le dépôt existe." 
        else
        echo "[✅] - Dépôt vérifié" 
        echo "[⏳] - Clonage du Dépôt en cours ..." 
        git clone -q $git_repository $tmp_path &> /dev/null
        chown www-data:www-data -R $tmp_path/
        rm -rf /var/www/public_html/*
        cp -rT $tmp_path $DEFAULT_WORK_DIR/

        if [ $? -ne 0 ]
        then
            echo "[❌] - Erreur lors du copie du dépôt $git_repository sur $DEFAULT_WORK_DIR " 
        else
            echo "[✅] - Dépôt $git_repository copié sur $DEFAULT_WORK_DIR " 
            echo $DEFAULT_WORK_DIR > ${ENTRYPOINT_PATH}/var/workdir_path.txt
        fi

        rm -rf $tmp_path 
    fi
fi

