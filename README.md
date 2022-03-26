# ILLIXR-docker

ILLIXR-docker is a GPU-enabled Docker container that provides a development-ready environment for ILLIXR, supporting GUI passthrough on both Xorg and Wayland. Independent of a Linux distribution, ILLIXR-docker is a streamlined method to try out and develop for ILLIXR.

## Features
- Preloaded with CUDA 11.4 Development Kit
- All GPUs are accessable in the container. ILLIXR is tested to launch on both AMD and Nvidia GPUs with or without OpenXR. **However, an Nvidia GPU is required to launch ILLIXR-docker as of right now**
- The default username and password are both `illixr`
- ILLIXR is installed in `/opt/ILLIXR` and tracks the master branch

## Prerequisites
1. Docker
2. Install `nvidia-docker2`. An installation guide by Nvidia is available [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for mainstream distributions.
3. Expose your xhost to Docker. An insecure but easy way is to `xhost +local:root`. To properly configure xhost, please consult the documentation [here](http://wiki.ros.org/docker/Tutorials/GUI)

## Creating the Container
### One-Line Command
``` docker run -d --privileged --name illixr-docker -e "DISPLAY=${DISPLAY}" --hostname illixr-docker -v /tmp/.X11-unix:/tmp/.X11-unix --gpus all illixr/illixr:nvidia-latest ```
### Using Docker Compose
After setting up some prerequisites, launching ILLIXR-docker is as simple as launching any docker image.
1. Install [Docker Compose](https://docs.docker.com/compose/install/)
2. Clone this repository
3. Run `sudo docker-compose up -d` to bring up the container
### Building the Image
To build the image from scratch and bring up the container, run
```
git submodule update --init
sudo PARALLEL_CORES=$(($(nproc)+1)) docker-compose up -d --build
```

## Launching ILLIXR
1. To access bash in your container, run `sudo docker exec -it illixr-docker /bin/bash`
2. Activate the `illixr-runner` conda environment by running `conda activate illixr-runner`
3. Run ILLIXR with the desired configuration: `./runner.sh configs/CONFIGURATION_NAME`

## Is my setup working?
1. Run `glmark2` to check that the OpenGL dispatch through glvnd is working
2. Run `vulkaninfo` to check whether vulkan loader is working
