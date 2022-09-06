#!/bin/bash

logs_file=${ENTRYPOINT_PATH}/logs/setup.log

ERROR=0
DEFAULT_WORK_DIR=$1

declare -a apache2_config_files=(
    "/etc/apache2/apache2.conf"
    "/etc/apache2/sites-available/000-default.conf"
    "/etc/apache2/sites-available/default-ssl.conf"
)

if [ -z ${DEFAULT_WORK_DIR} ] || [ ! -e ${DEFAULT_WORK_DIR} ]; then
    echo "[❌] - Erreur lors de la configuration apache et workdir : ${DEFAULT_WORK_DIR}"
else
    for config_file in "${apache2_config_files[@]}"
    do
        if [ ! -e $config_file ]; then
            echo "[⚠️] - Le fichier de config suivant n'as pas été trouvé : $config_file"
        else
            sed -i -e "s|DocumentRoot /var/www/html|DocumentRoot ${DEFAULT_WORK_DIR}|g" $config_file
            if [ $? -ne 0 ];then
                echo "[❌] - Erreur lors de la confiuration du fichie apache : $config_file"
                ERROR=1
            else
                echo "[✅] - Configuration du fichier apache: $config_file"
            fi
        fi
    done
fi

if [ $ERROR -eq 0 ];then
    echo "[✅] - Serveur apache configuré. Dossier root : ${DEFAULT_WORK_DIR}"
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
else
    echo "[⚠️] - Certains fichiers n'ont pas été configuré pour apache. Voir les erreur précedents"
fi

