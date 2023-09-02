# Dockerfile for WARA-PS ROS2 arena

# UNCOMMENT FOR HUMBLE 
ARG ROS_DISTRO=humble

ARG WORKSPACE=/opt/conceptio

FROM ros:${ROS_DISTRO} as update_stage

RUN apt update -y && apt dist-upgrade -y && apt install -y python3-pip

# Remote-ID 
RUN apt install -y bluez libgps-dev libconfig-dev libbluetooth-dev gpsd

FROM update_stage as dependency_stage

WORKDIR /opt/
COPY ["lrs2", "lrs2/"]
COPY ["conceptio", "conceptio/"]

ARG DEBIAN_FRONTEND=noninteractive

RUN pip3 install --upgrade setuptools==58.2.0

RUN rosdep install --from-paths conceptio/ --ignore-src -r -y

FROM dependency_stage as compilation_stage

WORKDIR /opt/conceptio/conceptio_msgs
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
	colcon build

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

FROM compilation_stage as pythonros_install

RUN apt install python3-rosinstall -y

WORKDIR /opt
COPY ["docker/ros_entryremoteid.sh", "/opt/ros_entrypoint.sh"]
RUN ["chmod", "+x", "/opt/ros_entrypoint.sh"]

COPY ["docker/.bashrc", "/root/.bashrc"]

CMD /bin/bash -c "/opt/ros_entrypoint.sh"