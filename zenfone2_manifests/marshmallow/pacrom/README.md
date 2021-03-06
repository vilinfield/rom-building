# Build PAC-ROM marshmallow for the Asus Zenfone 2 (Z00A + Z008)

## Notes

-- This guide is assuming you are running Debian or a Debian based operating system such as Ubuntu.

### Step One: Set up your environment 

```
-- Make sure your system is up to date:
$ sudo apt-get update
$ sudo apt-get upgrade
-- Install all build tools:
$ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 lzop maven pngcrush schedtool lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev squashfs-tools openjdk-7-jre openjdk-7-jdk
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
-- Make a folder to store the ROM's source code (pac can be replaced with whatever you want):
$ mkdir ~/pac 
$ cd ~/pac
-- Configure Git:
$ git config --global user.name "Your Name"
$ git config --global user.email "you@example.com"
```

### Step Three: Download the source 

```
-- Get the source initialized:
$ repo init -u https://github.com/PAC-ROM/pac-rom.git -b pac-6.0 -g all,-notdefault,-darwin
-- Download the local manifests (these are some changes to the code as well as a few of my own repos to get PAC-ROM to build):
$ cd .repo
$ mkdir local_manifests
$ cd local_manifests/
$ wget https://raw.githubusercontent.com/vilinfield/rom-building/master/zenfone2_manifests/marshmallow/pacrom/pacrom.xml
$ cd ../..
-- Download the source (this can take a while depending on internet speed):
$ repo sync -j4 --force-sync
```

### Step Four: Change some code

```
-- Swap dependencies files
$ cd vendor/pac/dependencies
$ rm Z008.dependencies
$ rm Z00A.dependencies
$ wget https://raw.githubusercontent.com/vilinfield/rom-building/master/zenfone2_manifests/marshmallow/pacrom/Z008.dependencies
$ wget https://raw.githubusercontent.com/vilinfield/rom-building/master/zenfone2_manifests/marshmallow/pacrom/Z00A.dependencies
cd ../..
```

### Step Five: Build

```
-- Build for your device (this can take time depending on the speed of your computer):
$ ./build-pac.sh Z00A
- OR ./build-pac.sh Z008
```

```
-- Between builds:
$ make clobber
```
