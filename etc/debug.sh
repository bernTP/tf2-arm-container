#!/bin/bash

export BOX64_LOG=3

if [[ -n "$1" ]]; then
    export BOX64_LOG=$1
fi

cd "${STEAMAPPDIR}"

# GAMEROOT=$(echo $PWD)
GAMEROOT=$(echo $PWD)

PLATFORM_DIR="linux"
PLATFORM_DIR="$PLATFORM_DIR"64

export LD_LIBRARY_PATH="${GAMEROOT}"/bin:"${GAMEROOT}"/bin/"$PLATFORM_DIR":$LD_LIBRARY_PATH

box64 "${STEAMAPPDIR}/srcds_linux64" -game "${STEAMAPP}" -console \
            -usercon \
            -port "${SRCDS_PORT}"
