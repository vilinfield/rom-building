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
$ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip
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
```

Install local manifests

Put these files under the du/.repo/local_manifests directory

https://github.com/vilinfield/rom-building/blob/master/local_manifest.xml

https://github.com/vilinfield/rom-building/blob/master/roomservice.xml

```
-- Download the source (This can take a while depending on internet speed):
$ repo sync -j4
```

### Step Four: Configure source

Cherry pick this commit to vendor/du/

In the config/common.mk file this is what has to change

```
https://github.com/kularny/android_vendor_du/commit/7180fec7ed607ea1077cd6c83b23a8f0abdca6e0
```

Update the file frameworks/base/tools/aapt/Image.cpp

```
-- Change line that says FILE* fp; to:
dFILE* volatile fp;﻿
```

### Step Five: Build it! 

```
-- Setup ccache:
$ nano ~/.bashrc
- Append export USE_CCACHE=1 to the end of this file.
$ prebuilts/misc/linux-x86/ccache/ccache -M 50G 
```

```
-- Load tools to build:
$ . build/envsetup.sh
-- Build for your device:
$ brunch Z00A
```

```
-- Between builds
$ make clobber
$ make clean
- make clean is optinal
```
