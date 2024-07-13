#!/bin/bash

if [ -z "$1" ]; then
    container_name="tf2_arm_0"
else
    container_name="tf2_arm_$1"
fi

sudo docker logs -f $container_name
