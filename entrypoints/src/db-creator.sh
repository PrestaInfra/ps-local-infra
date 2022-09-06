#!/bin/sh

logs_file=${ENTRYPOINT_PATH}/logs/setup.log

DEFAULT_DB_NAME="default_database_name"
CURRENT_DT_TM=$(date +%F%H%M%S)

MYSQL_MAX_DB_NAME=64

if [ "$PS_DB_NAME" = "<to be defined>" ] || [ -z "$PS_DB_NAME" ] ; then
   echo "[⚠️] - Nom de la base de données non défini" 
   DEFAULT_DB_NAME="${DEFAULT_DB_NAME}_${CURRENT_DT_TM}"
   echo "[⚠️] - Un nom par défaut sera défini pour la base données : $DEFAULT_DB_NAME" 
else
   DEFAULT_DB_NAME=$(echo $PS_DB_NAME | sed -e 's/ /_/g')
fi

# TODO : Check database name (@see : MySQL databases name restrictions)
DB_NAME=$DEFAULT_DB_NAME

if [ "$PS_DB_SERVER" = "" ]; then
    echo "[⚠️] - Vous devez spécifier une adresse serveur MySQL" 
elif [ "$PS_DB_SERVER" != "<to be defined>" ]; then
    RET=1
    MAX_RETRY=5
    COUNTER=0
    while [ $RET -ne 0 ]; do

        if [ $COUNTER -eq $MAX_RETRY ]; then
            echo "[❌] - Serveur MySQL $PS_DB_SERVER non disponible"
            break
        fi

        echo "[⏳] - Vérification disponibilité serveur MySQL : $PS_DB_SERVER " 
        mysql -h $PS_DB_SERVER -P $PS_DB_PORT -u $PS_DB_USER -p$PS_DB_PASSWD -e "status" > /dev/null 2>&1
        RET=$?

        if [ $RET -ne 0 ]; then
            echo "[⏳] - En attente de confirmation du démarrage du service MySQL" 
            sleep 5
        fi

        ((COUNTER++))
    done
        echo "[✅] - Serveur MySQL $PS_DB_SERVER est disponible !" 

        mysql -h $PS_DB_SERVER -P $PS_DB_PORT -u $PS_DB_USER -p$PS_DB_PASSWD -e "drop database if exists $PS_DB_NAME;" > /dev/null 2>&1

        if [ $? -ne 0 ];then
           echo "[❌] - Erreur lors de la suppresion de la base de donées : $PS_DB_NAME " 
        else
           echo "[✅] - Suppression de la base données : $PS_DB_NAME " 
        fi

        mysqladmin -h $PS_DB_SERVER -P $PS_DB_PORT -u $PS_DB_USER -p$PS_DB_PASSWD create $PS_DB_NAME --force; > /dev/null 2>&1

        if [ $? -ne 0 ];then
             echo "[❌] - Erreur lors de la création de la base de donées : $PS_DB_NAME " 
        else
             echo "[✅] - Création de la base données : $PS_DB_NAME " 
             if [ "$PROJECT_DB_REPOSITORY_URL" = "<to be defined>" ] || [ -z "$PROJECT_DB_REPOSITORY_URL" ] ; then
                 echo "[⚠️] - La base données : $PS_DB_NAME  est vide (aucune source de données definie)" 
             else
                 Linkregex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
                 if [[ $PROJECT_DB_REPOSITORY_URL =~ $Linkregex ]]
                 then 
                    response=$(curl --write-out %{http_code} --silent --output /dev/null "$PROJECT_DB_REPOSITORY_URL")
                    if [ "$response" != "200" ]; then
                        echo "[❌]: La source de données $PROJECT_DB_REPOSITORY_URL ne réponds/n'existe pas" 
                    else
                        curl $PROJECT_DB_REPOSITORY_URL | mysql -h $PS_DB_SERVER -P $PS_DB_PORT -u $PS_DB_USER -p$PS_DB_PASSWD $PS_DB_NAME
                        if [ $? -ne 0 ];then
                            echo "[❌] - Erreur lors de l'import de la base de données : $PS_DB_NAME avec la source distant $PROJECT_DB_REPOSITORY_URL " 
                        else
                            echo "[✅] - Import de la base de données : $PS_DB_NAME avec la source distant $PROJECT_DB_REPOSITORY_URL " 
                        fi
                    fi 
                 else
                    cat $PROJECT_DB_REPOSITORY_URL | mysql -h $PS_DB_SERVER -P $PS_DB_PORT -u $PS_DB_USER -p$PS_DB_PASSWD $PS_DB_NAME
                    if [ $? -ne 0 ];then
                        echo "[❌] - Erreur lors de l'import de la base de données fichier: $PS_DB_NAME avec la source local $PROJECT_DB_REPOSITORY_URL " 
                    else
                        echo "[✅] - Import de la base de données : $PS_DB_NAME avec la source local $PROJECT_DB_REPOSITORY_URL " 
                    fi
                 fi
             fi
        fi
fi
