#!/bin/bash

cd steamcmd

sudo docker build -t mhktp/steamcmd-arm:latest .

if [[ $? -ne 0 ]]; then
    exit 1
fi

cd "$OLDPWD/.."

sudo docker build -t mhktp/tf2-arm-server:latest -f src/Dockerfile .

if [[ $? -ne 0 ]]; then
    exit 1
fi

echo "Done"
