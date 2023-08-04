#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/opt/lrs2/install/local_setup.bash"
source "/opt/conceptio/rosbridge-suite/install/local_setup.bash"
echo "\n\t\t***CONCEPTIO-LRS2 Docker***\nIn order to open more terminals, run the following docker command:\ndocker exec -ti <container_name> bash\n"
exec "$@"
