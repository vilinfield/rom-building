# Rom Building - Build DU for the Asus Zenfone 2 (Z00A)

## Notes

-- This guide is assuming you are running a Debian based or Debian OS. (Debian, Ubuntu, Linux Mint, etc.)

### Step 1: Set up your environment 

```
-- Make sure your up to date:
$ sudo apt-get update
$ sudo apt-get upgrade
-- Install Java 7:
$ sudo apt-get install openjdk-7-jdk
$ sudo apt-get install openjdk-7-jre
-- Install build tools:
$ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 lzop maven pngcrush schedtool lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev squashfs-tools 
```

### Step Two: Configure Repo and Git  

```
-- Make directory for Repo, download it and add it to your path:
$ mkdir ~/bin
$ PATH=~/bin:$PATH
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
$ chmod a+x ~/bin/repo
-- Make a folder to store the ROM's source code:
$ mkdir ~/du 
$ cd ~/du
-- Configure Git:
$ git config --global user.name "Your Name"
$ git config --global user.email "you@example.com"
```

### Step Three: Download the source 

```
-- Get the source initialized:
$ repo init -u http://github.com/DirtyUnicorns/android_manifest.git -b m-caf
-- Download the local manifests:
$ cd .repo/local_manifests/
$ wget https://raw.githubusercontent.com/vilinfield/rom-building/master/local_manifest.xml 
$ wget https://raw.githubusercontent.com/vilinfield/rom-building/master/roomservice.xml 
$ cd ../..
-- Download the source (This can take a while depending on internet speed):
$ repo sync -j4
```

### Step Four: Configure source

```
-- Add ffmpeg support:
$ nano vendor/du/config/common.mk
- Add the contents of http://github.com/kularny/android_vendor_du/commit/7180fec7ed607ea1077cd6c83b23a8f0abdca6e0 to the proper location of the file.
-- Fix a build error:
$ nano frameworks/base/tools/aapt/Images.cpp
- Add the contents of https://github.com/vilinfield/android_frameworks_base/commit/098f8ff0e7f2007fe34b87739211a9ee0d472ee4 to the proper location of the file.
```

### Step Five: Build setup

```
-- Setup ccache:
$ nano ~/.bashrc
- Append 'export USE_CCACHE=1' without quotes to the end of this file.
$ prebuilts/misc/linux-x86/ccache/ccache -M 50G 
```

### Step Six: Build

```
-- Load tools:
$ . build/envsetup.sh
-- Build for your device:
$ brunch Z00A
```

```
-- Between builds:
$ make clobber
$ . build/envsetup.sh
```
