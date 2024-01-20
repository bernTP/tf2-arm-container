#!/bin/bash

if [ -z "$1" ]; then
    container_name="bernardesman"
else
    container_name="$1"
fi

sudo docker stop -t 0 $container_name
sudo docker rm $container_name
echo "Deleted :" $container_name
