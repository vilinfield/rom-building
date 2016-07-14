# rom-building

################################################################
################################################################
### BUILDING ANDROID FROM SOURCE ###################
################################################################
################################################################

In this guide, I will go over how to build Android on your Linux machine. This particular tutorial will focus on Ubuntu 14.04 but this should work with any version of Linux; it does need to be 64-bit however. I will leave the installation of that up to you, Google is a wonderful resource. If you don't have a good computer but still want to build, check out this thread on XDA: http://forum.xda-developers.com/chef-central/android/guide-how-to-build-rom-google-cloud-t3360430

Formatting!!!
If something has a $ in front of it, that is a command you need to run in your terminal window. Don't include the $ or the space that follows it.



#########################################
### Step One: set up your environment ###
#########################################

You have two options here, the lazy way or the non-lazy way.

Lazy way (recommended!):
-- Get curl installed so we can pull the required packages
$ sudo apt-get install curl
-- Grab a script and execute it
$ curl https://raw.githubusercontent.com/akhilnarang/scripts/master/build-environment-setup.sh | bash

Non-lazy way:
-- Grab Java 7:
$ sudo apt-get update
$ sudo apt-get install openjdk-7-jdk
$ sudo apt-get install openjdk-7-jre

-- Install build tools
$ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip

If you are on Ubuntu 16.04, see this guide for the setup part (steps 1-7): http://odste.blogspot.com/2016/04/guide-to-compiling-android-on-ubuntu.html

#########################################
### Step Two: Configure Repo and Git  ###
#########################################

If you have any problems with the below commands, try running as root:
$ sudo -s

Git is an open source version control system which is incredibly robust for tracking changes across repositories. Repo is Google's tool for working with Git in the context of Android. More reading if you are interested: https://source.android.com/source/developing.html

Run these commands to get repo and git all working:
$ mkdir ~/bin
$ PATH=~/bin:$PATH
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
$ chmod a+x ~/bin/repo
$ mkdir ~/<foldername> (eg. mkdir ~/DU or ~/PN-Layers)
$ cd ~/<foldername>
$ git config --global user.name "Your Name"
$ git config --global user.email "you@example.com"



#########################################
#### Step Three: Download the source ####
#########################################

When you go to build a ROM, you must download its source. All, if not most, ROMs will have their source code available on Github. To properly download the source, follow these steps:
-- Go to your ROM's Github (e.g. http://github.com/DirtyUnicorns)
-- Search for a manifest (usually called manifest or android_manifest).
-- Go into the repo and make sure you are in the right branch (located right under the Commits tab).
-- Go into the README and search for a repo init command. If one exists, copy and paste it into the terminal and hit enter.
-- If one does not exist, you can make one with this formula: repo init -u <url_of_manifest_repo>.git -b <branch_you_want_to_build>. For example:
$ repo init -u http://github.com/DirtyUnicorns/android_manifest.git -b m
-- After the repo has been initialized, run this command to download the source:
$ repo sync
-- This process can take a while depending on your internet connection.



#########################################
### Step Four: Build it! ##########
#########################################

Here's the moment of truth... time to build the ROM! This process could take 15 minutes to many hours depending on the speed of your PC but assuming that you have followed the instructions so far, it should be smooth sailing.

Before you compile, you may also consider setting up ccache if you can spare about 50GB. If not, skip this section. ccache is a compiler cache, which keeps previously compiled code stored so it can be easily reused. This speeds up build times DRASTICALLY.

Open your bashrc or equivalent:
$ nano ~/.bashrc
- Append export USE_CCACHE=1 to the end of this file then hit ctrl-X, Y, and enter.

After that, run this command:
$ prebuilts/misc/linux-x86/ccache/ccache -M 50G (or however much you want).

After this, load up the compilation commands:
$ . build/envsetup.sh

Then, tell it which device you want to make and let it roll:
$ brunch <device>

If you get an error here, make sure that you have downloaded all of the proper vendor files from your ROM's repository.

Once you tell it to brunch your device, the computer will start building. You will know that it is done when you see a message saying make completed and telling you where your flashable zip is located.

Whenever you build again, make sure you run a clean build every time by placing this command in between the other two:
$ make clobber

That's it! You successfully compiled a ROM from scratch :) By doing this, you control when you get the new features, which means as soon as they are available on Github. After this, you may even want to start contributing, one of the greatest things about Android and open source software in general.



#########################################
###   Support    #############
#########################################

If you have any questions, you can reach out to me via Hangouts (natechancellor@gmail.com) or Telegram (@nathanchance). I may not respond right away but I will do my best to help you out.



#########################################
####   Special thanks    ##########
#########################################

@Mazda-- for spearheading the Dirty Unicorns project, his dedication to open source, and helping me out at random points during compilation.
@BeansTown106 for the various advice and guidance he has provided plus his contributions to the open source community through the Pure Nexus Project.
@akhilnarang for his build environment scripts.
@npjohnson for the Ubuntu 16.04 Java 7 instructions.
