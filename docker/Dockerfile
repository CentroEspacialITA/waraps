# Dockerfile for WARA-PS ROS2 arena

ARG ROS_DISTRO=humble
ARG WORKSPACE=/opt/conceptio

FROM ros:${ROS_DISTRO}

WORKDIR /opt/
COPY ["lrs2", "lrs2/"]
COPY ["conceptio", "conceptio/"]

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt dist-upgrade && apt install -y python3-pip xvfb x11vnc fluxbox guvcview fswebcam ffmpeg \
	bluez libgps-dev libconfig-dev libbluetooth-dev nano wget libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev \
	build-essential cmake libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev at

RUN pip3 install --upgrade --user setuptools==58.2.0

RUN rosdep install --from-paths lrs2/ --ignore-src -r -y

RUN rosdep install --from-paths conceptio/ --ignore-src -r -y

#RUN apt install -y ros-humble-xacro ros-humble-turtlesim \ 
#	ros-humble-geographic-msgs ros-humble-gazebo-msgs \
#	 python3-colcon-ros python3-colcon-bash python3-pyproj

#RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
#	apt-get update && rosdep install --from-paths \
#	lrs2/ --ignore-src -y -r 

WORKDIR /opt/conceptio/conceptio_msgs
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
	colcon build

#WORKDIR /opt/lrs2
#RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
#	colcon build

# We need the forked version of rosbridge-suite (tsender) to include the TCP protocol.
#RUN apt-get install -y ros-${ROS_DISTRO}-rosbridge-suite
WORKDIR /opt/conceptio/rosbridge_suite
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
	colcon build

WORKDIR /opt/conceptio/remote_id
RUN gcc ./src/bluetooth/remote.c ./src/bluetooth/advle.c ./src/bluetooth/scan.c \ 
	$(pkg-config --libs --cflags bluez libgps libconfig) -lm -pthread -o remote

#WORKDIR /opt/conceptio/librealsense2
#RUN mkdir build && cd build && cmake ../ -DBUILD_EXAMPLES=true && make && make install

WORKDIR /opt
COPY ["docker/ros_entrypoint.sh", "/opt/ros_entrypoint.sh"]
RUN ["chmod", "+x", "/opt/ros_entrypoint.sh"]

COPY ["docker/.bashrc", "/root/.bashrc"]

CMD /bin/bash -c "source /root/.bashrc && /opt/ros_entrypoint.sh"

