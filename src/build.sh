#!/bin/bash

cd steamcmd

docker build -t berntp/steamcmd-arm:latest .

if [[ $? -ne 0 ]]; then
    exit 1
fi

cd "$OLDPWD/.."

docker build -t berntp/tf2-arm-server:latest -f src/Dockerfile .

if [[ $? -ne 0 ]]; then
    exit 1
fi

echo "Done"
