#!/bin/bash
#OWNROM SETUP AND BUILD SCRIPT
#   ____                 _____   ____  __  __ 
#  / __ \               |  __ \ / __ \|  \/  |
# | |  | |_      ___ __ | |__) | |  | | \  / |
# | |  | \ \ /\ / / '_ \|  _  /| |  | | |\/| |
# | |__| |\ V  V /| | | | | \ \| |__| | |  | |
#  \____/  \_/\_/ |_| |_|_|  \_\\____/|_|  |_|
#GITHUB: https://github.com/OwnROM/Setup.sh
VERSION="v0.5.7"

#=====FUNCTIONS=====#
#PAUSE COMMAND
pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
} 
#EXIT COMMAND
leave(){
 read -n1 -rsp $'Press any key to exit...\n'
}
#GENERAL WAIT COMMAND - ITS USED A LOT
waitf(){
sleep 3
clear
}
#PUT AFTER A COMMAND TO SEE IF IT HAS WORKED OR NOT
iserror(){
if [ $? -eq 0 ]; then
    echo "Continuing"
else
    echo ""
    echo "WARNING: The previous command has failed."
    echo "If the command above shows an error, please try to resolve it."
    echo "If you can't fix the problem yourself you can get help on our Google+ community here: https://plus.google.com/communities/108869588356214314591"
    echo ""
    echo "If you need a more detailed log please rerun the script using the command below:"
    echo "./setup.sh 2>&1 | tee setup.log"
    echo ""
    echo "If there is a problem with the script itself open an issue on Github here: https://github.com/OwnROM/Setup.sh"
    echo ""
    echo "To exit press enter, to continue running the script type y"
    read -p "Enter: [exit] " ERRORCON
    ERRORCON=${ERRORCON:-exit}
    if [ "$ERRORCON" = "y" ]
    then
    echo "Continuing"  
    clear
    else
    exit
    fi
fi
}

#=====SECTIONS=====#
#NOTE THESE ARE NOT IN ORDER
#menuf - main menu (build, sync, setup or start scripts)
#startf - first run script
#androidsdkf - install Android sdk
#usbportsf - setup usb ports
#dependenciesf - install dependencies
#repof - install repo
#sourcef - setup source
#downloadsourcef - download source code
#ccachef - setup ccache
#buildf - build for OwnROM
#syncf - sync OwnROM
#fullsyncf - sync cyanogenmod sources

#MENU
menuf(){
while :
do
    clear
    cat<<EOF
================================
OWNROM SCRIPT MENU
--------------------------------
Setup - Install and setup 
required files for building 
[only needs to be run once]
Build - Build for OwnROM
Sync - Just sync OwnROM sources
or both OwnROM's and CM's
Settings - Change settings file
Quit - Quit the script [cancel]

Please enter your choice:

Setup              (1)
Build              (2)
Sync               (3)
Settings           (4)
Quit               (5)
--------------------------------
================================
EOF
read -n1 -s
case "$REPLY" in
    "1")  
        clear
        if [ "$ANDROIDSDK" = "y" ]; then
        androidsdkf 
        else
        echo "Skip AndroidSDK"
        clear
        fi
        usbportsf
        dependenciesf 
        repof 
        sourcef 
        downloadsourcef
        ccachef 
    ;;
    "2") 
        clear
        syncf
        fullsyncf
        buildf
    ;;
    "3")
        clear
        syncf
        fullsyncf
    ;;
    "4")
        clear
        startf
        ;;
    "5")  exit                      ;;
        * )  echo "Invalid option"     ;;
        esac
        sleep 1
    done
}

#START
startf(){
clear
echo "
============================================
  ____                 _____   ____  __  __ 
 / __ \               |  __ \ / __ \|  \/  |
| |  | |_      ___ __ | |__) | |  | | \  / |
| |  | \ \ /\ / / '_ \|  _  /| |  | | |\/| |
| |__| |\ V  V /| | | | | \ \| |__| | |  | |
 \____/  \_/\_/ |_| |_|_|  \_\\____/|_|  |_|
 
===========SETUP AND BUILD SCRIPT============
"
echo "Welcome to the OwnROM setup script $VERSION
This script allows you to setup a working environment on your computer that will allow you to build for OwnROM
Since this is your first time running the script you will be guided though a setup wizard to choice the settings you want to build with
"
pause
waitf
touch /home/$USER/ownset.sh
clear
echo "What package manager do you use (apt-get, aptitude, yum, dnf or pacman)"
read -p "Enter: [apt-get] " PACKAGEMANAGER
PACKAGEMANAGER=${PACKAGEMANAGER:-apt-get}
clear
if [ "$PACKAGEMANAGER" = "pacman" ]
then
clear
echo "Do you want to install Yaourt (y if its not installed, n if its already installed or if you want to skip installing it)"
read -p "Enter: [y] " YAOURT
YAOURT=${YAOURT:-y}
clear
else
echo "Skipping yaourt install"
clear
fi
clear
echo "Please enter your device's codename (ex Nexus 5 = hammerhead)"
read -p "Enter: [hammerhead] " DEVICECODE
DEVICECODE=${DEVICECODE:-hammerhead}
clear
echo "Would you like to install the Android SDK? (y or n)"
read -p "Enter: [n] " ANDROIDSDK
ANDROIDSDK=${ANDROIDSDK:-n}
clear
echo "Where do you want to initialize the OwnROM source code? (ex: /home/$USER/ownrom , /media/$USER/yourdrive/ownrom , etc.)"
read -p "Enter: [/home/$USER/ownrom] " SOURCEDIR
SOURCEDIR=${SOURCEDIR:-/home/$USER/ownrom}
clear
echo "Enter number of jobs to repo sync with (jobs = number of CPU cores ex 4 cores = 4)"
read -p "Enter: [4] " SYNCJOBS
SYNCJOBS=${SYNCJOBS:-4}
clear
echo "How much CCache do you want to utilize? (in GB 50 is recommended 0 for none)"
read -p "Enter: [0] " CCACHESIZE
CCACHESIZE=${CCACHESIZE:-0}
clear
echo "Enter path to directory you want to use for ccache(ex Something like /home/$USER/.ccache)"
read -p "Enter: [/home/$USER/.ccache] " CCACHEDIR
CCACHEDIR=${CCACHEDIR:-/home/$USER/.ccache}
clear
echo "Writing settings file"
echo "#!/bin/bash" > /home/$USER/ownset.sh
echo "SETFILE="y" #[y/n] Whether to run the setup or just build (n = run setup, y = don't run setup)" >> /home/$USER/ownset.sh
echo "DEVICECODE=$DEVICECODE #Device code name (for example Nexus 5 = hammerhead)" >> /home/$USER/ownset.sh
echo "CCACHESIZE=$CCACHESIZE #CCache size in GB (to disable use 0)" >> /home/$USER/ownset.sh
echo "CCACHEDIR=$CCACHEDIR #CCache directory " >> /home/$USER/ownset.sh
echo "SOURCEDIR=$SOURCEDIR #Directory for the OwnROM source code" >> /home/$USER/ownset.sh
echo "SYNCJOBS=$SYNCJOBS #Number of jobs to sync with (Should equal the number of cpu cores, for example 4 cores = 4 jobs)" >> /home/$USER/ownset.sh
echo "ANDROIDSDK=$ANDROIDSDK #[y/n] Whether or not the Android SDK should be installed" >> /home/$USER/ownset.sh
echo "PACKAGEMANAGER=$PACKAGEMANAGER #Operating systems package manager" >> /home/$USER/ownset.sh
echo "YAOURT=$YAOURT #Yaourt aur helper for arch linux" >> /home/$USER/ownset.sh
waitf
echo "Settings file has been wrote"
leave
}

#ANDROID SDK
androidsdkf(){
echo "Installing Android SDK"
waitf
wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
tar -xvzf android-sdk_r24.4.1-linux.tgz
mv /home/$USER/android-sdk_r24.4.1-linux /home/$USER/android-sdk
rm android-sdk_r24.4.1-linux.tgz
echo "export PATH=${PATH}:~/android-sdk/tools" | tee -a ~/.bashrc
echo "export PATH=${PATH}:~/android-sdk/platform-tools" | tee -a ~/.bashrc
echo "export PATH=${PATH}:~/bin" | tee -a ~/.bashrc
echo "PATH="$HOME/android-sdk/tools:$HOME/android-sdk/platform-tools:$PATH"" | tee -a ~/.profile
waitf
echo "We will now open the SDK. In the SDK check every box from the latest android version and all build tools and select install"
sleep 5
clear
android
waitf
echo "Android SDK has been installed"
waitf
}

##SYNC
syncf(){
echo "Syncing OwnROM sources"
waitf
cp $SOURCEDIR/vendor/ownrom/tools/sync-own.sh $SOURCEDIR/sync-own.sh
iserror
cd $SOURCEDIR
bash sync-own.sh
iserror
waitf
echo "Sources have been synced"
waitf
}

##FULLSYNC
fullsyncf(){
echo "Would you like to run a full sync? - It is only recommended if you are doing a major build"
read -p "Enter: [n] " SYNCIT
SYNCIT=${SYNCIT:-n}
waitf
if [ "$SYNCIT" = "y" ]
then
echo "Starting full sync"
cd $SOURCEDIR
repo sync -j$SYNCJOBS
iserror
echo "Fullsync has completed"
waitf
else
echo "Skipping fullsync"
waitf
fi
}

##USB PORTS
usbportsf(){
echo "Setting up USB ports"
waitf
echo "
#Acer
SUBSYSTEM=="usb", ATTR{idVendor}=="0502", MODE="0666"
#ASUS
SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", MODE="0666"
#Dell
SUBSYSTEM=="usb", ATTR{idVendor}=="413c", MODE="0666"
#Foxconn
SUBSYSTEM=="usb", ATTR{idVendor}=="0489", MODE="0666"
#Garmin-Asus
SUBSYSTEM=="usb", ATTR{idVendor}=="091E", MODE="0666"
#Google
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666"
#HTC
SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", MODE="0666"
#Huawei
SUBSYSTEM=="usb", ATTR{idVendor}=="12d1", MODE="0666"
#K-Touch
SUBSYSTEM=="usb", ATTR{idVendor}=="24e3", MODE="0666"
#KT Tech
SUBSYSTEM=="usb", ATTR{idVendor}=="2116", MODE="0666"
#Kyocera
SUBSYSTEM=="usb", ATTR{idVendor}=="0482", MODE="0666"
#Lenevo
SUBSYSTEM=="usb", ATTR{idVendor}=="17EF", MODE="0666"
#LG
SUBSYSTEM=="usb", ATTR{idVendor}=="1004", MODE="0666"
#Motorola
SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666"
#NEC
SUBSYSTEM=="usb", ATTR{idVendor}=="0409", MODE="0666"
#Nook
SUBSYSTEM=="usb", ATTR{idVendor}=="2080", MODE="0666"
#Nvidia
SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0666"
#OTGV
SUBSYSTEM=="usb", ATTR{idVendor}=="2257", MODE="0666"
#Pantech
SUBSYSTEM=="usb", ATTR{idVendor}=="10A9", MODE="0666"
#Philips
SUBSYSTEM=="usb", ATTR{idVendor}=="0471", MODE="0666"
#PMC-Sierra
SUBSYSTEM=="usb", ATTR{idVendor}=="04da", MODE="0666"
#Qualcomm
SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", MODE="0666"
#SK Telesys
SUBSYSTEM=="usb", ATTR{idVendor}=="1f53", MODE="0666"
#Samsung
SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666"
#Sharp
SUBSYSTEM=="usb", ATTR{idVendor}=="04dd", MODE="0666"
#Sony Ericsson
SUBSYSTEM=="usb", ATTR{idVendor}=="0fce", MODE="0666"
#Toshiba
SUBSYSTEM=="usb", ATTR{idVendor}=="0930", MODE="0666"
#ZTE
SUBSYSTEM=="usb", ATTR{idVendor}=="19D2", MODE="0666"
" | sudo tee -a /etc/udev/rules.d/51-android.rules
iserror
sudo chmod a+r /etc/udev/rules.d/51-android.rules
waitf
echo "USB ports have been setup"
waitf
}

##REQUIRED DEPENDENCIES
dependenciesf(){
echo "Installing required dependencies"
if [ "$PACKAGEMANAGER" = "apt-get"]
then
waitf
sudo apt-get update && sudo apt-get -y install git-core python gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.8-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev openjdk-7-jre openjdk-7-jdk pngcrush schedtool libxml2 libxml2-utils xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev lib32ncurses5-dev gcc-multilib liblz4-* pngquant ncurses-dev texinfo gcc gperf patch libtool automake g++ gawk subversion expat libexpat1-dev python-all-dev binutils-static libgcc1:i386 bc libcloog-isl-dev libcap-dev autoconf libgmp-dev build-essential gcc-multilib g++-multilib pkg-config libmpc-dev libmpfr-dev lzma* liblzma* w3m phablet-tools android-tools-adb screen maven tmux 
iserror
waitf
elif [ "$PACKAGEMANAGER" = "aptitude"]
then
waitf
sudo aptitude update && sudo aptitude install git-core python gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.8-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev openjdk-7-jre openjdk-7-jdk pngcrush schedtool libxml2 libxml2-utils xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev lib32ncurses5-dev gcc-multilib liblz4-* pngquant ncurses-dev texinfo gcc gperf patch libtool automake g++ gawk subversion expat libexpat1-dev python-all-dev binutils-static libgcc1:i386 bc libcloog-isl-dev libcap-dev autoconf libgmp-dev build-essential gcc-multilib g++-multilib pkg-config libmpc-dev libmpfr-dev lzma* liblzma* w3m phablet-tools android-tools-adb screen maven tmux 
iserror
waitf
elif [ "$PACKAGEMANAGER" = "yum"]
then
waitf
sudo yum update && sudo yum install glibc.i686 glibc-devel.i686 libstdc++.i686 zlib-devel.i686 ncurses-devel.i686 libX11-devel.i686 libXrender.i686 libXrandr.i686 gcc gcc-c++ gperf flex bison glibc-devel.{x86_64,i686} zlib-devel.{x86_64,i686} ncurses-devel.i686 libsx-devel readline-devel.i686 perl-Switch java-1.7.0-openjdk maven
iserror
waitf
elif [ "$PACKAGEMANAGER" = "dnf"]
then
waitf
sudo dnf update && sudo dnf install glibc.i686 glibc-devel.i686 libstdc++.i686 zlib-devel.i686 ncurses-devel.i686 libX11-devel.i686 libXrender.i686 libXrandr.i686 gcc gcc-c++ gperf flex bison glibc-devel.{x86_64,i686} zlib-devel.{x86_64,i686} ncurses-devel.i686 libsx-devel readline-devel.i686 perl-Switch java-1.7.0-openjdk maven
iserror
waitf
elif [ "$PACKAGEMANAGER" = "pacman"]
then
waitf
sudo pacman -Sy && sudo pacman -S gcc git gnupg flex bison gperf sdl wxgtk squashfs-tools curl ncurses zlib schedtool perl-switch zip unzip libxslt python2-virtualenv bc gcc-multilib lib32-zlib lib32-ncurses lib32-readline rsync maven jdk7-openjdk
iserror
# Install yaourt
if [ "$YAOURT" = "y" ]
then
waitf
git clone https://aur.archlinux.org/package-query.git
iserror
cd package-query
makepkg -si
iserror
cd ..
git clone https://aur.archlinux.org/yaourt.git
iserror
cd yaourt
makepkg -si
iserror
cd ..
waitf
else
echo "Skipping yaourt install"
waitf
fi
sudo yaourt -S libtinfo libtinfo-5 ncurses5-compat-libs lib32-ncurses5-compat-libs
iserror
waitf
else
echo "Not a valid package manager"
iserror
fi
echo "Dependencies have been installed"
waitf
}

##REPO
repof(){
echo "Installing Repo"
waitf
mkdir ~/bin
echo "export PATH=~/bin:$PATH" | tee -a ~/.bashrc
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
iserror
chmod a+x ~/bin/repo
waitf
echo "Repo has been installed"
waitf
}

##SOURCE
sourcef(){
echo "Initializing source code"
waitf
echo "Initializing OwnROM Source at $SOURCEDIR"
waitf
mkdir -p $SOURCEDIR
cd $SOURCEDIR
repo init -u https://github.com/OwnROM/android -b own-mm
iserror
waitf
echo "Source Code has been initialized"
waitf
}

##DOWNLOAD SOURCE 
downloadsourcef(){
echo "Downloading source code"
waitf
repo sync -j$SYNCJOBS
iserror
waitf
echo "Source code has been downloaded"
waitf
}

##CCACHE
ccachef(){
echo "Setup CCache"
waitf
echo "export USE_CCACHE=1" | tee -a ~/.bashrc
echo "export CCACHE_DIR=$CCACHEDIR" | tee -a ~/.bashrc
prebuilts/misc/linux-x86/ccache/ccache -M $CCACHESIZE
waitf
echo "CCache has been setup"
waitf
}

##BUILD
buildf(){
export USE_CCACHE=1
echo "Building for OwnROM"
waitf
cd $SOURCEDIR
iserror
if [ grep $DEVICECODE vendor/ownrom/ownrom-build-targets ];
then
export OWNROM_BUILDTYPE=OFFICIAL;
fi
source build/envsetup.sh
iserror
lunch ownrom_$DEVICECODE-userdebug
iserror
time mka ownrom
iserror
waitf
echo "OwnROM has finished building"
echo "If an error has occurred that means the build failed and you should try to fix the error yourself or ask for help"
sleep 10
}

#=====SETTINGS-AND-START=====#
source /home/$USER/ownset.sh
if [[ $SETFILE = y ]]; then
    menuf
else
    startf
fi

#=====EXAMPLE-SETTINGS=====#
#!/bin/bash
#SETFILE="n" #[y/n] Whether to run the setup or just build (n = run setup, y = don't run setup)
#DEVICECODE="hammerhead" #Device code name (for example Nexus 5 = hammerhead)
#CCACHESIZE="50" #CCache size in GB (to disable use 0)
#CCACHEDIR="/home/$USER/.ccache" #CCache directory 
#SOURCEDIR="/home/$USER/ownrom" #Directory for the OwnROM source code
#SYNCJOBS="4" #Number of jobs to sync with (Should equal the number of cpu cores, for example 4 cores = 4 jobs)
#ANDROIDSDK="y" #[y/n] Whether or not the Android SDK should be installed
#PACKAGEMANAGER="apt-get" #Operating systems package manager
#YAOURT="y" aur helper for arch linux
