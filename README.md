# WARA-PS 
WARA-PS Core Arena fork as a docker image.


# 1. Introduction

This repository should be used for all CONCEPTIO agents willing to test and connect to the WARA-PS/LRS2 arena. 

Presently there is no docker image for LRS2, so the Dockerfile provided here uses osrf:ros-humble-desktop as a base image, copies all directories from "lrs2" (which are submodules) to the image, sources the ROS 2 installation and compiles all LRS2 packages. 

## Docker 101
A docker container is like a virtual machine running an Operating System with preinstalled software. It is used to quickly run applications that rely on specific libraries without spending time configuring the environment. That way, new agents can be added to the arena as quickly as possible. If your ROS2 node/package uses a specific library, you can also add it to the docker image. 

You can either build the image yourself or download the image and create a new Docker container to run it:

# 2. Building the image

1. Download [Docker](https://www.docker.com/).
2. Clone this repository using [GitHub Desktop](https://desktop.github.com/) or [git](https://git-scm.com/).
3. To fetch LRS2 packages, open a PowerShell terminal on the root cloned folder and run ```git submodule init``` followed by ```git submodule update --remote```. This will get the most up-to-date packages from the swedish side.
5. Open a PowerShell terminal on the root cloned folder and run ```docker build -f docker/Dockerfile . -t arena:1.0``` to start building the image. Don't forget the ```.```! This will take around 5 minutes.


# 3. Downloading the image
(TODO) -> maybe self-host it at local server? (3.8 GB)


# 4. Using the arena
On the root cloned folder, start the container with ```docker run -ti arena:1.0```

Check [lrs_doc](https://gitlab.liu.se/lrs2/lrs_doc) section 2.2 for more info.

By default, LRS2 workspace is at the /opt/lrs2 folder and CONCEPTIO workspace is at /opt/conceptio. ROS2 is installed in /opt/ros. 


# Roadmap for september
- [X] Run arena locally.
- [ ] Create topics for UTM.
- [ ] See arena agents in VR-Forces.
- [ ] Add an agent to the arena.
- [ ] Control a real (live) agent and see the behavior in Gazebo/Rviz/VR-Forces

