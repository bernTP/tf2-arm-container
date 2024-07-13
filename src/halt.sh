#!/bin/bash

if [ -z "$1" ]; then
    container_name="tf2_arm_0"
else
    container_name="tf2_arm_$1"
fi

sudo docker stop -t 0 $container_name
sudo docker rm $container_name

if [[ $? -eq 0 ]]; then
    echo "Deleted :" $container_name
fi
