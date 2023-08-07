#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/opt/lrs2/install/local_setup.bash"
source "/opt/conceptio/rosbridge_suite/install/local_setup.bash"
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
NC=$(tput sgr0)


echo -e -n "\n\t\t ${GREEN}*** CONCEPTIO-LRS2 Docker *** ${CYAN}\nIn order to open more terminals, run the following docker command:\ndocker exec -ti -p PORT_RANGE:PORT_RANGE <container_name> bash\n ${NC}"
exec "$@"
