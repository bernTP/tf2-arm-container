#!/bin/bash

cd ..

sudo docker build -t tf2:latest -f bullseye/Dockerfile .
echo "Done"

cd -
