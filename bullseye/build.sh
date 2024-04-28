#!/bin/bash

cd steamcmd

sudo docker build -t steamcmd_arm:latest .

if [[ $? -ne 0 ]]; then
    cd -
    exit 1
fi

cd -
cd ..

sudo docker build -t tf2_arm:latest -f bullseye/Dockerfile .

if [[ $? -ne 0 ]]; then
    cd -
    exit 1
fi
cd -

echo "Done"
