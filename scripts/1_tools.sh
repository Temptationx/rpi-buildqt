#!/bin/bash

set -e

SCRIPTDIR=$(dirname "$0")
source $SCRIPTDIR/utils/utils.sh
source $SCRIPTDIR/env.sh

mkdir -p $(dirname $(realpath ${RPIDEV_TOOLS}))

echo
echo == Fix GCC and G++ ==
echo
if [ ! -f /usr/bin/arm-linux-gnueabihf-gcc.real ]; then
	mv /usr/bin/arm-linux-gnueabihf-gcc /usr/bin/arm-linux-gnueabihf-gcc.real
fi
if [ ! -f /usr/bin/arm-linux-gnueabihf-g++.real ]; then
	mv /usr/bin/arm-linux-gnueabihf-g++ /usr/bin/arm-linux-gnueabihf-g++.real
fi

cp ${SCRIPTDIR}/resources/gcc.sh /usr/bin/arm-linux-gnueabihf-gcc
cp ${SCRIPTDIR}/resources/gcc.sh /usr/bin/arm-linux-gnueabihf-g++

chmod +x /usr/bin/arm-linux-gnueabihf-gcc
chmod +x /usr/bin/arm-linux-gnueabihf-g++

echo
echo == Fix ld ==
echo
if [ ! -f /usr/bin/ld.real ]; then
	mv /usr/bin/ld /usr/bin/ld.real
fi

cp ${SCRIPTDIR}/resources/ld.sh /usr/bin/ld

chmod +x /usr/bin/ld

echo
echo == Fix as ==
echo
mkdir -p /usr/bin/arm-linux-gnueabihf/6
ln -s /usr/bin/arm-linux-gnueabihf-as /usr/bin/arm-linux-gnueabihf/6/as

echo 
echo == Fix asm header ==
echo 
ln -s /usr/include/asm-generic /usr/include/asm

echo
echo == Tools ok ==
echo
