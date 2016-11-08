# Build Dirty Unicorns Nougat for the Asus Zenfone 2 (Z00A + Z008)

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
$ repo init -u http://github.com/DirtyUnicorns/android_manifest.git -b n-caf
-- Download the local manifests (these are some changes to the code as well as a few of my own repos to get Dirty Unicorns to build):
$ cd .repo
$ mkdir local_manifests
$ cd local_manifests/
$ wget https://raw.githubusercontent.com/vilinfield/rom-building/master/du-n.xml
$ cd ../..
-- Download the source (this can take a while depending on internet speed):
$ repo sync -j4 --force-sync
```

### Step Four: Add needed code

```
-- Fix snap camera build error
$ nano packages/apps/Snap/src/com/android/camera/CameraActivity.java

- Delete lines 1825-1831 shown below

        if (mPowerShutter && mInCameraApp) {
             getWindow().addPrivateFlags(
                     WindowManager.LayoutParams.PRIVATE_FLAG_PREVENT_POWER_KEY);
         } else {
             getWindow().clearPrivateFlags(
                     WindowManager.LayoutParams.PRIVATE_FLAG_PREVENT_POWER_KEY);
         }
         
-- Make a du version of the x86 mediaextractor seccomp (need to fix a build error)

$ cd frameworks/av/services/mediaextractor/minijail/seccomp_policy/
$ cp mediaextractor-seccomp-x86.policy mediaextractor-seccomp-x86-du.policy

-- Add in DTB for the zenfone 2
$ nano build/core/generate_extra_images.mk

- Add this to line 79 (after ALL_MODULES.$(LOCAL_MODULE).INSTALLED += $(INSTALLED_PERSISTIMAGE_TARGET))

#----------------------------------------------------------------------
# Generate device tree image (dt.img)
#----------------------------------------------------------------------
ifeq ($(strip $(BOARD_KERNEL_SEPARATED_DT)),true)
ifeq ($(strip $(BUILD_TINY_ANDROID)),true)
include device/qcom/common/dtbtool/Android.mk
endif

DTBTOOL := $(HOST_OUT_EXECUTABLES)/dtbTool$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img

possible_dtb_dirs = $(KERNEL_OUT)/arch/$(TARGET_KERNEL_ARCH)/boot/dts/ $(KERNEL_OUT)/arch/arm/boot/
dtb_dir = $(firstword $(wildcard $(possible_dtb_dirs)))

define build-dtimage-target
    $(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
    $(hide) $(DTBTOOL) -o $@ -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm/boot/
    $(hide) chmod a+r $@
endef

$(INSTALLED_DTIMAGE_TARGET): $(DTBTOOL) $(INSTALLED_KERNEL_TARGET)
	$(build-dtimage-target)

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_DTIMAGE_TARGET)
ALL_MODULES.$(LOCAL_MODULE).INSTALLED += $(INSTALLED_DTIMAGE_TARGET)
endif
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
-- Build for your device (this can take time depending on the speed of your computer):
$ brunch Z00A
- OR brunch Z008
```

```
-- Between builds:
$ make clobber
- you may also run 'make clean' as well
$ . build/envsetup.sh
```