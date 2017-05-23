#!/bin/bash
# OWNROM BUILD SCRIPT
#   ____                 _____   ____  __  __ 
#  / __ \               |  __ \ / __ \|  \/  |
# | |  | |_      ___ __ | |__) | |  | | \  / |
# | |  | \ \ /\ / / '_ \|  _  /| |  | | |\/| |
# | |__| |\ V  V /| | | | | \ \| |__| | |  | |
#  \____/  \_/\_/ |_| |_|_|  \_\\____/|_|  |_|
# VERSION="v0.7.0"

export OWNROM_BUILDTYPE=OFFICIAL
. build/envsetup.sh
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
lunch ownrom_d852-userdebug
make update-api && make ownrom -j5
