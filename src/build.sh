#!/bin/bash

cd steamcmd

sudo docker build -t berntp/steamcmd-arm:sourcemod .

if [[ $? -ne 0 ]]; then
    exit 1
fi

cd "$OLDPWD/.."

sudo docker build -t berntp/tf2-arm-server:sourcemod -f src/Dockerfile .

if [[ $? -ne 0 ]]; then
    exit 1
fi

echo "Done"
