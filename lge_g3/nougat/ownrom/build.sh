#!/bin/bash
# OWNROM SETUP AND BUILD SCRIPT
#   ____                 _____   ____  __  __
#  / __ \               |  __ \ / __ \|  \/  |
# | |  | |_      ___ __ | |__) | |  | | \  / |
# | |  | \ \ /\ / / '_ \|  _  /| |  | | |\/| |
# | |__| |\ V  V /| | | | | \ \| |__| | |  | |
#  \____/  \_/\_/ |_| |_|_|  \_\\____/|_|  |_|
# VERSION="v0.9.0"

echo "Do you need to setup this install? [y or n]"
read SETUP

if [ $SETUP == "y" ]
then
  sudo apt update
  sudo apt upgrade
  sudo apt-get install git-core ninja-build gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 lzop maven pngcrush schedtool lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev squashfs-tools openjdk-8-jre openjdk-8-jdk
  mkdir ~/bin
  PATH=~/bin:$PATH
  curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
  chmod a+x ~/bin/repo
  mkdir ~/ownrom
  git config --global user.name "vilinfield"
  git config --global user.email "vilinfield@gmail.com"
else
  echo "Skipping setup"
fi

echo "Do you need to init. the sources? [y or n]"
read SOURCE

if [ $SOURCE == "y" ]
then
  cd ownrom
  repo init -u git://github.com/OwnROM/android -b own-n
  cd .repo
  mkdir local_manifests
  cd local_manifests
  wget https://raw.githubusercontent.com/vilinfield/rom-building/master/lge_g3/nougat/ownrom/ownrom.xml
  cd ../..
else
  echo "Skipping init."
fi

echo "Do you need to sync the sources? [y or n]"
read SYNC

if [ $SYNC == "y" ]
then
  cd ownrom
  repo sync -j5 --force-sync
  cd ..
else
  echo "Skipping sync"
fi

echo "Starting to build"

echo "What is your device code?"
read DEVICENAME
echo "Building for" $DEVICENAME

echo "Do you need to make a clean build? [y or n]"
read CLEAN

if [ $CLEAN == "y" ]
then
  cd ownrom
  make clean
  cd ..
else
  echo "Making dirty build"
fi

echo "Building"
cd ownrom
wget https://raw.githubusercontent.com/vilinfield/rom-building/master/lge_g3/nougat/ownrom/ota_conf_$DEVICENAME
mv ota_conf_$DEVICENAME ota_conf
export OWNROM_BUILDTYPE=OFFICIAL
. build/envsetup.sh
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
lunch ownrom_$DEVICENAME-userdebug
make update-api && make ownrom -j5
