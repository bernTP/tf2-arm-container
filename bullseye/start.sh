#!/bin/bash

if [ -z "$1" ]; then
    container_name="bernardesman"
else
    container_name="$1"
fi

if [ -z "$2" ]; then
    game_folder_name="tf2"
else
    game_folder_name="$2"
fi

if [ -z "$3" ]; then
    cfg_folder_name="normal"
else
    cfg_folder_name="$3"
fi

# get passwords from this (incomplete)
. bashenv

SERV_TARGET="/home/steam/tf-dedicated"
SERV_SRC="$HOME/$game_folder_name"

SERV_CFG_TARGET="$SERV_TARGET/tf/cfg"
SERV_CFG_SRC=$(realpath "../etc/cfg/$cfg_folder_name")

mkdir -p "$SERV_SRC"
sudo docker run -d -it --net=host --platform linux/amd64 \
    --name=$container_name \
    -v $SERV_SRC:$SERV_TARGET \
    -v $SERV_CFG_SRC:$SERV_CFG_TARGET \
    -e SRCDS_TOKEN=$SERVER_TOKEN \
    -e SRCDS_RCONPW=$RCONPWD \
    tf2:latest

# user expected to sigint to quit the log trace
sudo docker logs -f $container_name
