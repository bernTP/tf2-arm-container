#!/bin/bash

##
## DEPRECATED : THIS IS FOR 32 BITS TF2 SERVER
##

echo "DEPRECATED : THIS IS FOR 32 BITS TF2 SERVER"
echo "Continue ? (CTRL-C/SIGINT to abort)"
read

# allow arm kernel to run i386 executable (steamcmd and tf2 as srcds_linux)
if [[ $(dpkg --print-architecture) != 'arm64' ]]; then
    echo "Your device is not arm."
    exit 1
fi

OG_DIR=$(pwd)

sudo apt update
sudo apt install qemu qemu-user-static binfmt-support git make

# compile the latest version, a bug in the IOPL assertion may occur.
cd /tmp
git clone https://gitlab.com/qemu-project/qemu.git
cd qemu
git submodule update --init --recursive
sudo apt-get install git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build libcapstone-dev libaio-dev pip
sudo apt install flex bison -y

./configure \
    --prefix=$(cd ..; pwd)/qemu-user-static \
    --static \
    --disable-system

make -j8
make install

sudo update-binfmts --disable qemu-i386
sudo mv /usr/bin/qemu-i386-static /usr/bin/qemu-i386-static.old
sudo cp /tmp/qemu-user-static/bin/qemu-i386 /usr/bin/qemu-i386-static
sudo update-binfmts --enable qemu-i386

cd $OG_DIR
