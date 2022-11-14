#!/bin/bash

cd /var/www
rm -rf html

ps_instance_creator_latest_release_tag=`curl --silent "https://api.github.com/repos/PrestaInfra/ps-instance-creator/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
ps_instance_creator_latest_release_zip=https://github.com/PrestaInfra/ps-instance-creator/releases/download/${ps_instance_creator_latest_release_tag}/ps-instance-creator.zip

curl -o html.zip $ps_instance_creator_latest_release_zip
unzip html.zip
rm html.zip
chown -R www-data:www-data html



