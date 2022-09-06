#!/bin/sh

WORK_DIR=$(cat /home/entrypoints/var/workdir_path.txt)
cd $WORK_DIR

mkdir log app/logs
chmod +w -R admin-dev/autoupgrade \
    app/config \
    app/logs \
    app/Resources/translations \
    cache \
    config \
    download \
    img \
    log \
    mails \
    modules \
    themes \
    translations \
    upload \
    var

echo "[⏳] - Composer install en cours ..." 
composer install > /dev/null 2>&1 ## Silent mode
echo "[✅] - Fim composer install" 

echo "[⏳] - Make assets en cours ..." 
make assets > /dev/null 2>&1 ## Silent mode
echo "[✅] - Fim make assets" 

a2enmod rewrite
service apache2 restart


if [ ! -z "$PS_AUTO_INSTALL" ] && [ "$PS_AUTO_INSTALL" = "1" ] ; then
   echo "[⏳] - Installation automatique en cours ..." 

   php install-dev/index_cli.php \
        --domain=${PS_DOMAIN}:${PROJECT_APP_PORT} \
        --db_server=${PS_DB_SERVER} \
        --db_name=${PS_DB_NAME} \
        --db_user=${PS_DB_USER} \
        --db_password=${PS_DB_PASSWD} \
        --email=${PS_ADMIN_EMAIL} \
        --step=${PS_STEP} \
        --base_uri=${PS_BASE_URI} \
        --db_clear=${PS_DB_CLEAR} \
        --db_create=${PS_DB_CREATE} \
        --prefix=${PS_DB_PREFIX} \
        --engine=${PS_DB_ENGINE} \
        --name=${PS_SHOP_NAME} \
        --activity=${PS_SHOP_ACTIVITY} \
        --country=${PS_SHOP_COUNTRY} \
        --firstname=${PS_ADMIN_FIRSTNAME} \
        --lastname=${PS_ADMIN_LASTNAME} \
        --password=${PS_ADMIN_PASSWORD} \
        --license=${PS_LICENCE} \
        --theme=${PS_SHOP_THEME} \
        --enable_ssl=${PS_ENABLE_SSL} \
        --rewrite=${PS_REWRITE_ENGINE} \
        --fixtures=${PS_FIXTURES} 

   rm -rf var/cache/* # Fix cache issue
   chown -R www-data:www-data ../*
   echo "[✅] - Fim installation" 
else
   echo "[⚠️] - Vous choisi l'sinatllation manuel" 
fi
