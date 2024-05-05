#!/bin/bash

cd steamcmd

sudo docker build -t steamcmd_arm:latest .

if [[ $? -ne 0 ]]; then
    exit 1
fi

cd "$OLDPWD/.."

sudo docker build -t tf2_arm:latest -f src/Dockerfile .

if [[ $? -ne 0 ]]; then
    exit 1
fi

echo "Done"
