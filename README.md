# Cross compile Qt 5.9.1 for Raspberry Pi 3 running Raspbian Stretch on Ubuntu 17.04(bit) host use GCC 6.3.0

Based on https://wiki.qt.io/RaspberryPi2EGLFS, https://thebugfreeblog.blogspot.com and https://github.com/raspberrypi/tools

## Notes
 - Uses the `arm-linux-gnueabihf-gcc-6` toolchain
 - Tested only on RPi 3
 - Tested on clean `Ubuntu 17.04 (64 bit)` as host and clean `Raspbian Stretch Lite 2017-09-07` on device
 - Make sure to use 64 bit host OS as that's what the used toolchain is built for
 - To use the toolchain manually from console you must run `source env.sh` first to setup environment variables

## Guide
1. on host install tools and clone this repo
    ```sh
    # install tools
    sudo apt-get install build-essential sshpass git python pkg-config re2c gperf bison flex ninja-build python ruby gcc-multilib g++-multilib rsync libstdc++-6-dev-armhf-cross libstdc++6-armhf-cross libsfstdc++-6-dev-armhf-cross libsfstdc++6-armhf-cross libstdc++-6-pic-armhf-cross pkg-config-arm-linux-gnueabihf cpp-arm-linux-gnueabihf g++-arm-linux-gnueabihf g++-multilib-arm-linux-gnueabihf gcc-multilib-arm-linux-gnueabihf gcc-arm-linux-gnueabihf libstdc++-6-dev-armhf-cross libstdc++6-armhf-cross libsfstdc++-6-dev-armhf-cross libsfstdc++6-armhf-cross libstdc++-6-pic-armhf-cross pkg-config-arm-linux-gnueabihf cpp-arm-linux-gnueabihf g++-arm-linux-gnueabihf g++-multilib-arm-linux-gnueabihf gcc-multilib-arm-linux-gnueabihf gcc-arm-linux-gnueabihf

    # clone this repo
    mkdir -p ~/raspi
    cd ~/raspi
    git clone https://github.com/Kukkimonsuta/rpi-buildqt.git .
    
    # add executable permissions (this may not be required)
    chmod +x scripts/0_init.sh
    cd scripts
    ./0_init.sh
    ```
2. update values in `env.sh` (`RPIDEV_DEVICE_*`, qt version and other settings)
3. on RPi (ideally use clean 'RASPBIAN JESSIE LITE' image)
    ```sh
    # change gpu memory to 256 MB and Expand File System for SD Card
    sudo raspi-config

    # ensure EGL/GLES libraries are available
    sudo rm /usr/lib/arm-linux-gnueabihf/libEGL.so* /usr/lib/arm-linux-gnueabihf/libGLESv2.so*
    
    sudo ln -s /opt/vc/lib/libEGL.so /usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0
    sudo ln -s /opt/vc/lib/libGLESv2.so /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0
    
    sudo ln -s libEGL.so.1.0.0 /usr/lib/arm-linux-gnueabihf/libEGL.so.1
    sudo ln -s libGLESv2.so.2.0.0 /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2
    
    sudo ln -s libEGL.so.1.0.0 /usr/lib/arm-linux-gnueabihf/libEGL.so
    sudo ln -s libGLESv2.so.2.0.0 /usr/lib/arm-linux-gnueabihf/libGLESv2.so

    # install tools and dependencies
    sudo apt-get update
    sudo apt-get install rsync

    sudo apt-get install libssh-4 libevdev2 libwacom2 libmtdev1 libxkbcommon0 libfontconfig1 libpulse-mainloop-glib0 libsmbclient libinput10 libts-0.0-0 libts-bin libts-dev fbi ntpdate smbclient libssh-dev libsmbclient libsmbclient-dev rsync libpulse-dev libv4l-dev libavformat-dev libavutil-dev libavcodec-dev libswscale-dev libboost-all-dev libbz2-dev libxslt1.1 libsnappy-dev htop lirc python-pip i2c-tools git omxplayer lrzsz libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 libxcb-image0-dev libxcb-shm0 libxcb-shm0-dev libxcb-icccm4 libxcb-icccm4-dev libxcb-sync1 libxcb-sync-dev libxcb-render-util0 libxcb-render-util0-dev libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-glx0-dev libasound2-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-0 libxkbcommon-x11-dev libxcb-xinerama0-dev libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 libxcb-image0-dev libxcb-shm0 libxcb-shm0-dev libxcb-icccm4 libxcb-icccm4-dev libxcb-sync1 libxcb-sync-dev libxcb-render-util0 libxcb-render-util0-dev libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-glx0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-0 libxkbcommon-x11-dev libxcb-xinerama0 libxcb-xinerama0-dev libdrm-dev libxcomposite1 libxcomposite-dev libxcursor-dev libxcursor1 libxcb-cursor-dev libxcb-cursor0 libxi6 libxi-dev libxrandr-dev libxrandr2 libxtst-dev libxtst6 khronos-api libcap-dev libcups2-dev libsnappy-dev libsrtp0-dev libevent-dev libflac-dev libflac++-dev libjsoncpp-dev libspeex-dev libspeexdsp-dev libopusfile-dev libopus-dev libasound2-dev libbz2-dev libcap-dev libcups2-dev libdrm-dev libegl1-mesa-dev libfontconfig1-dev libgcrypt11-dev libglu1-mesa-dev libicu-dev libnss3-dev libpci-dev libpulse-dev libssl-dev libudev-dev libxcomposite-dev libxcursor-dev libxdamage-dev libxrandr-dev libxtst-dev libsnappy-dev libsrtp0-dev libevent-dev libflac-dev libflac++-dev libjsoncpp-dev libspeex-dev libspeexdsp-dev libopusfile-dev libopus-dev libdbus-1-3 libdbus-1-dev libasound2-dev libpulse-dev gstreamer1.0-omx libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libssl1.0-dev libssl1.0.2 libvpx-dev libsrtp0-dev libsnappy-dev libnss3-dev libssh-dev libsmbclient-dev libv4l-dev libbz2-dev
    # qtbase
    sudo apt-get install libudev-dev libinput-dev libts-dev libmtdev-dev libjpeg-dev libfontconfig1-dev libssl-dev libdbus-1-dev libglib2.0-dev libxkbcommon-dev
    
    # qtmultimedia
    sudo apt-get install libasound2-dev libpulse-dev gstreamer1.0-omx libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

    # qtwebengine
    sudo apt-get install libvpx-dev libsrtp0-dev libsnappy-dev libnss3-dev

    # piomxtextures
    sudo apt-get install libssh-dev libsmbclient-dev libv4l-dev libbz2-dev
    ```

4. run `1_tools.sh` - downloads and prepares toolchain
5. run `2_sysroot.sh` - synchronizes libs and headers from device to build host
6. run `3.0_download_qtbase.sh` - downloads latest version of `qtbase` from git (destroys all local changes!)
7. run `3.1_build_qtbase.sh` - builds `qtbase` and installs it to configured directories
8. run `4.0_download_modules.sh` - downloads latest versions of all configured or explicitly specified (ex. `4.0_download_modules.sh qtmultimedia`) modules from git (destroys all local changes!)
9. run `4.1_build_modules.sh` - builds all configured or explicitly specified (ex. `4.1_build_modules.sh qtmultimedia`) modules and installs them to configured directories
10. run `5.0_download_piomxtextures.sh` - downloads latest version of `piomxtextures`
11. run `5.1_build_piomxtextures.sh` - builds `piomxtextures` and installs it to configured directories
12. run `6_copy_to_device.sh` - copies built QT to configured directory on device and runs ldconfig
13. on RPi run `~/piomxtextures_pocplayer /opt/vc/src/hello_pi/hello_video/test.h264`

note, my changes

###### gcc use wrong ld,
replace with this script
#!/bin/bash

set -e
echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Custom ld"
whole_cmd="$(ps -o args= $PPID)"
eval arr_cmd=($whole_cmd)
m_path=${arr_cmd[0]}

if [[ $m_path == *"gnueabihf"* ]]; then
  exec "/usr/bin/arm-linux-gnueabihf-ld" "$@"
else
  exec "/usr/bin/ld.real" "$@"
fi

###### wrong as
sudo mkdir -p /usr/bin/arm-linux-gnueabihf/6
ln -s /usr/bin/arm-linux-gnueabihf-as /usr/bin/arm-linux-gnueabihf/6/as

###### wrong header folder
sudo ln -s /usr/include/asm-generic /usr/include/asm