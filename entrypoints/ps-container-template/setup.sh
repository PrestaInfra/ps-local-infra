#!/bin/bash

CONTAINER_ALREADY_STARTED=/home/entrypoints/var/CONTAINER_ALREADY_STARTED

if [ ! -e $CONTAINER_ALREADY_STARTED ]
then
  if [ "$IS_ADVANCED_CONTAINER" = "1" ]; then
    if [ ! -z "PS_ENTRY_POINT_SCRIPT_URL" ]; then
        echo "[⏳] - Running shell script ${PS_ENTRY_POINT_SCRIPT_URL} ..."
        curl -L $PS_ENTRY_POINT_SCRIPT_URL -o installer.sh
        chmod +x installer.sh
        ./installer.sh
      else
        echo "[⚠️] - Missing shell script : ${PS_ENTRY_POINT_SCRIPT_URL}"
    fi
  else
    echo "[⚠️] - Is a empty container. You need to install you project manually"
  fi
fi