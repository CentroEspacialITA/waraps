# Dockerfile for WARA-PS ROS2 arena

# UNCOMMENT FOR CAR DOCKER IMAGE
ARG ROS_DISTRO=foxy

ARG WORKSPACE=/opt/conceptio

FROM ros:${ROS_DISTRO} as update_stage

WORKDIR /opt/
COPY ["lrs2", "lrs2/"]
COPY ["conceptio", "conceptio/"]
COPY ["aws/", "/root/deepracer_ws"]

ARG DEBIAN_FRONTEND=noninteractive


RUN apt update -y && apt dist-upgrade -y && apt install -y python3-pip  \   
	# Remote-ID 
	bluez libgps-dev libconfig-dev libbluetooth-dev nano wget gpsd \ 
	# IntelLibSense2
	libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev build-essential cmake libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev at  \
	# Deepracer
	python3-rosinstall

RUN pip3 install --upgrade --user setuptools==58.2.0

RUN rosdep install --from-paths lrs2/ --ignore-src -r -y

RUN rosdep install --from-paths conceptio/ --ignore-src -r -y


FROM update_stage as compilation_stage

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

WORKDIR /opt/conceptio/remote_id/RemoteID
RUN mkdir build && \
	cd build && \
 	cmake .. && \
  	make

WORKDIR /opt/conceptio/remote_id/ros2_ws
RUN colcon build

RUN apt install python3-rosinstall -y

WORKDIR /root/deepracer_ws
RUN cd aws-deepracer-launcher && ./install_dependencies.sh
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && cd aws-deepracer-launcher/ && rosws update
RUN rosdep install -i --from-path . -y 
RUN pip3 install openvino-dev==2021.4.2
#RUN . /opt/ros/${ROS_DISTRO}/setup.sh && cd /var/lib/intel/ && colcon build 


# Uncomment lines below to compile LibRealSense2	
#WORKDIR /opt/conceptio/librealsense2
#RUN mkdir build && cd build && cmake ../ -DBUILD_EXAMPLES=true && make && make install

WORKDIR /opt
COPY ["docker/ros_entrypoint.sh", "/opt/ros_entrypoint.sh"]
RUN ["chmod", "+x", "/opt/ros_entrypoint.sh"]

COPY ["docker/.bashrc", "/root/.bashrc"]

CMD /bin/bash -c "source /root/.bashrc && ./opt/ros_entrypoint.sh"

