# Build crdroid 7.1 for the Asus Zenfone 2 (Z00A + Z008)

## Notes

-- This guide is assuming you are running a Debian or Debian based operating system. (Debian, Ubuntu, Linux Mint, Etc.)

-- Also this guide most likely wont work at the present

### Step 1: Set up your environment 

```
-- Make sure your system is up to date:
$ sudo apt-get update
$ sudo apt-get upgrade
-- Install all build tools:
$ sudo apt-get install git-core ninja-build gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 lzop maven pngcrush schedtool lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev squashfs-tools openjdk-8-jre openjdk-8-jdk
-- Install tmux if your going to be using ssh (optional)
$ sudo apt-get install tmux
```

### Step Two: Configure Repo and Git  

```
-- Make a directory for Repo, download it and add it to your path so it can be executed system wide:
$ mkdir ~/bin
$ PATH=~/bin:$PATH
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
$ chmod a+x ~/bin/repo
-- Make a folder to store the ROM's source code (du can be replaced with whatever you want):
$ mkdir ~/du 
$ cd ~/du
-- Configure Git:
$ git config --global user.name "Your Name"
$ git config --global user.email "you@example.com"
```

### Step Three: Download the source 

```
-- Get the source initialized:
$ repo init -u https://github.com/crdroidandroid/android -b 7.1
-- Download the local manifests (these are some changes to the code as well as a few of my own repos to get crdroid to build):
$ cd .repo
$ mkdir local_manifests
$ cd local_manifests/
$ wget https://raw.githubusercontent.com/vilinfield/rom-building/master/crdroid.xml
$ cd ../..
-- Download the source (this can take a while depending on internet speed):
$ repo sync -j4 
```

### Step Five: Build setup

```
-- Setup ccache (optional - for the second command replace 100G with the ammount you want cached):
$ nano ~/.bashrc
- Append 'export USE_CCACHE=1' without quotes to the end of this file.
$ prebuilts/misc/linux-x86/ccache/ccache -M 100G 
```

### Step Six: Build

```
-- Load build tools:
$ . build/envsetup.sh
-- Fix heap error
$ export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
$ ./prebuilts/sdk/tools/jack-admin kill-server
$ ./prebuilts/sdk/tools/jack-admin start-server
-- Build for your device (this can take time depending on the speed of your computer):
$ brunch Z00A
- OR brunch Z008
```

```
-- Between builds:
$ make clobber
$ make clean
```
