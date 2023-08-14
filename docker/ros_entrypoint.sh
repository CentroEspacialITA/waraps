#!/bin/bash
set -e


export DISPLAY=:20
Xvfb $DISPLAY -screen 0 1366x768x16 &
x11vnc -display $DISPLAY -passwd C2801it@  -N -forever -rfbport 8000 &

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
#source "/opt/lrs2/install/local_setup.bash"
source "/opt/conceptio/rosbridge_suite/install/setup.bash"
source "/opt/conceptio/conceptio_msgs/install/setup.bash"
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
NC=$(tput sgr0)



echo "${GREEN}   _____ ____  _   _  _____ ______ _____ _______ _____ ____  ";
echo "  / ____/ __ \| \ | |/ ____|  ____|  __ \__   __|_   _/ __ \ ";
echo " | |   | |  | |  \| | |    | |__  | |__) | | |    | || |  | |";
echo " | |   | |  | | . \ | |    |  __| |  ___/  | |    | || |  | |";
echo " | |___| |__| | |\  | |____| |____| |      | |   _| || |__| |";
echo "  \_____\____/|_| \_|\_____|______|_|      |_|  |_____\____/ ";
echo "                                                             ";



echo -e -n "\n\t\t${CYAN}\nIn order to open more terminals, run the following docker command:\ndocker exec -ti -p PORT_RANGE:PORT_RANGE <container_name> bash\n ${NC}"
exec "$@"
