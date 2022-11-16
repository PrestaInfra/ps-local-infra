#!/bin/bash

ps_instance_creator_latest_release_tag=`curl --silent "https://api.github.com/repos/PrestaInfra/ps-instance-creator/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
ps_instance_creator_latest_release_zip=https://github.com/PrestaInfra/ps-instance-creator/releases/download/${ps_instance_creator_latest_release_tag}/ps-instance-creator.zip

wget $ps_instance_creator_latest_release_zip
unzip ps-instance-creator.zip
rm ps-instance-creator.zip
mv ps-instance-creator/ /var/www/

declare -a apache2_config_files=(
    "/etc/apache2/apache2.conf"
    "/etc/apache2/sites-available/000-default.conf"
    "/etc/apache2/sites-available/default-ssl.conf"
)

for config_file in "${apache2_config_files[@]}"
    do
	if [ ! -e $config_file ]; then
            echo "Apache config file not found : $config_file"
        else
            sed -i -e "s|DocumentRoot /var/www/html|DocumentRoot /var/www/ps-instance-creator|g" $config_file
        fi
done

chown -R www-data:www-data /var/www/ps-instance-creator
chmod 777 /var/run/docker.sock
/etc/init.d/apache2 restart


