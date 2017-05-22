#!/bin/bash
# OWNROM BUILD SCRIPT
#   ____                 _____   ____  __  __ 
#  / __ \               |  __ \ / __ \|  \/  |
# | |  | |_      ___ __ | |__) | |  | | \  / |
# | |  | \ \ /\ / / '_ \|  _  /| |  | | |\/| |
# | |__| |\ V  V /| | | | | \ \| |__| | |  | |
#  \____/  \_/\_/ |_| |_|_|  \_\\____/|_|  |_|
# VERSION="v0.6.0"

echo "Setting up..."
export I_WANT_A_QUAIL_STAR=true
export OWNROM_BUILDTYPE=OFFICIAL
. build/envsetup.sh
lunch ownrom_d852-userdebug
echo "Starting build..."
make -j5
echo "Done"
