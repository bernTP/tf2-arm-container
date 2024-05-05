#!/bin/bash

container_ids=$(sudo docker ps -a --filter "name=tf2_arm_" --format "{{.ID}}")
container_array=($container_ids)
container_nb=${#container_array[@]}
new_container_id=$container_nb

container_flags="-d"

if [ -n "$1" ]; then
    if [[ $1 == "dev" ]]; then
        container_flags="--user root --rm --entrypoint /bin/bash"
        dev_flags="y"
    fi
    container_name="$1"
else
    container_name="tf2_arm_$new_container_id"
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

if [ -z "$4" ]; then
    server_token_length=${#ARR_SERVER_TOKENS[@]}
    if (( new_container_id < server_token_length )); then
        SERVER_TOKEN=${ARR_SERVER_TOKENS[$new_container_id]}
    else
        echo "Error : no more server account token... using none"
    fi
else
    SERVER_TOKEN="$2"
fi

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
    mhktp/tf2-arm-server:latest
