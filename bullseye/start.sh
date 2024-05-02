#!/bin/bash

if [ -n "$1" ]; then
    if [[ $1 == "dev" ]]; then
        container_flags="--user root --rm --entrypoint /bin/bash"
        dev_flags="y"
    else
        container_flags="-d"
    fi
    container_name="$1"
else
    container_name="bernardesman"
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
SERV_CFG_SRC="$HOME/cfg_$game_folder_name"
SERV_REPO_CFG_SRC=$(realpath "../etc/cfg/$cfg_folder_name")

mkdir -p "$SERV_SRC"
mkdir -p "$SERV_CFG_SRC"
cp -r $SERV_REPO_CFG_SRC/* $SERV_CFG_SRC
sudo chmod -R 777 $SERV_SRC
sudo chmod -R 777 $SERV_CFG_SRC
sudo docker run -it $container_flags --net=host \
    --name=$container_name \
    -v $SERV_SRC:$SERV_TARGET \
    -v $SERV_CFG_SRC:$SERV_CFG_TARGET \
    -e SRCDS_TOKEN=$SERVER_TOKEN \
    -e SRCDS_RCONPW=$RCONPWD \
    tf2_arm:latest

if [ -z "$dev_flags" ]; then
    # user expected to sigint to quit the log trace
    sudo docker logs -f $container_name
fi
