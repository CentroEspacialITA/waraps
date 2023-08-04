# Dockerfile for WARA-PS ROS2 arena

ARG ROS_DISTRO=humble
ARG WORKSPACE=/opt/conceptio

FROM osrf/ros:${ROS_DISTRO}-desktop

WORKDIR /opt/
COPY ["lrs2", "lrs2/"]

RUN apt update && apt install -y python3-pip
RUN pip3 install --upgrade --user setuptools==58.2.0

RUN apt install -y ros-humble-xacro ros-humble-turtlesim \ 
	ros-humble-geographic-msgs ros-humble-gazebo-msgs \
	 python3-colcon-ros python3-colcon-bash python3-pyproj

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
	apt-get update && rosdep install --from-paths \
	lrs2/ --ignore-src -y -r 


WORKDIR /opt/lrs2
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
	colcon build

RUN apt-get install -y ros-${ROS_DISTRO}-rosbridge-suite


COPY docker/ros_entrypoint.sh .

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

