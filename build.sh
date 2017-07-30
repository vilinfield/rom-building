#!/bin/bash
# OWNROM SETUP AND BUILD SCRIPT
#   ____                 _____   ____  __  __
#  / __ \               |  __ \ / __ \|  \/  |
# | |  | |_      ___ __ | |__) | |  | | \  / |
# | |  | \ \ /\ / / '_ \|  _  /| |  | | |\/| |
# | |__| |\ V  V /| | | | | \ \| |__| | |  | |
#  \____/  \_/\_/ |_| |_|_|  \_\\____/|_|  |_|
# VERSION="v0.9.2"

echo "Do you need to setup the ROM development files? [y or n]"
read SETUP

if [ $SETUP == "y" ]
then
  sudo apt update
  sudo apt upgrade
  sudo apt-get install git-core ninja-build gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 lzop maven pngcrush schedtool lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev squashfs-tools openjdk-8-jre openjdk-8-jdk bc
  mkdir ~/bin
  PATH=~/bin:$PATH
  curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
  chmod a+x ~/bin/repo
  mkdir ~/ownrom
  echo "Whats your git username?"
  read GITUSERNAME
  git config --global user.name $GITUSERNAME
  echo "Whats your git email?"
  read GITEMAIL
  git config --global user.email $GITEMAIL
else
  echo "Skipping setup"
fi

echo "Do you need to initialize the OwnROM sources? [y or n]"
read SOURCE

if [ $SOURCE == "y" ]
then
  cd ownrom
  repo init -u git://github.com/OwnROM/android -b own-n
  cd ..
else
  echo "Skipping initialization"
fi

echo "Are you building for the LG G3 or Google Nexus 4? [y or n]"
read LGNEXUS

if [ $LGNEXUS == "y" ]
then
  cd ownrom
  cd .repo
  mkdir local_manifests
  cd local_manifests
  rm ownrom.xml
  wget https://raw.githubusercontent.com/vilinfield/rom-building/master/ownrom/ownrom.xml
  cd ../..
else
  echo "Building for other device"
fi

echo "Do you need to sync the OwnROM sources? [y or n]"
read SYNC

if [ $SYNC == "y" ]
then
  cd ownrom
  repo sync -j5 --force-sync
  cd ..
else
  echo "Skipping sync"
fi

echo "What is your device code? [ex: d852]"
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

echo "Do you need to update the apis? - Used to fix quailstar issue if it occurs [y or n]"
read APIUPDATE

if [ $APIUPDATE == "y" ]
then
  cd ownrom
  make update-api 
  cd ..
else
  echo "Skipping api update"
fi

echo "Is this an offical build? [y or n]"
read APIUPDATE

if [ $APIUPDATE == "y" ]
then
  cd ownrom
  export OWNROM_BUILDTYPE=OFFICIAL
  echo "Will make OFFICAL build"
  cd ..
else
  echo "Will make UNOFFICAL build"
fi

echo "Starting build... Press enter to continue"
read DOIT
cd ownrom
if [ $LGNEXUS == "y" ]
then
  rm ota_conf
  wget https://raw.githubusercontent.com/vilinfield/rom-building/master/ownrom/ota_conf
else
  echo ""
fi
. build/envsetup.sh
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
lunch ownrom_$DEVICENAME-userdebug
make ownrom -j5