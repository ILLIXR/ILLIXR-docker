# ILLIXR-docker

ILLIXR-docker is a GPU-enabled Docker container that provides a development-ready environment for ILLIXR, supporting GUI passthrough on both Xorg and Wayland. Independent of a Linux distribution, ILLIXR-docker is a streamlined method to try out or develop for ILLIXR.

## Specifications
- Equipped with CUDA 11.4 Development Kit (with nvcc available)
- All GPUs are accessable in the container. ILLIXR is tested to launch on both AMD and Nvidia GPUs with or without OpenXR. **However, an Nvidia GPU is required to launch ILLIXR-docker as of right now**
- The default username and password are both `illixr`
- ILLIXR is installed in `/opt/ILLIXR` and tracks the master branch

## Installation
After setting up some prerequisites, launching ILLIXR-docker is as simple as launching any docker image.
1. Install `nvidia-docker2`. An installation guide by Nvidia is available [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for mainstream distributions.
2. Install [Docker Compose](https://docs.docker.com/compose/install/)
3. Expose your xhost to Docker. An insecure but easy way is to `xhost +local:root`. To properly configure xhost, please read the documentation [here](http://wiki.ros.org/docker/Tutorials/GUI)
4. Clone this repository
5. Run `sudo UID_GID="$(id -u):$(id -g)" docker-compose up -d` to bring up the container

## Is my setup working?
It's better to make sure the container can access the host's X server before we start downloading the assets and compile ILLIXR:
1. Run `sudo docker exec -it illixr-docker /bin/bash` 
2. Run `glmark2` to check that OpenGL dispatch through glvnd is working
3. Run `vulkaninfo` to check vulkan loader is working

## Usage
1. To access bash in your container, run `sudo docker exec -it illixr-docker /bin/bash`
2. Activate the `illixr-runner` conda environment by running `conda activate illixr-runner`
3. Run ILLIXR with the desired configuration: `./runner.sh configs/CONFIGURATION_NAME`

## Building the Image
To build the image from scratch and bring up the container, run `PARALLEL_CORES=$(($(nproc)+1))  UID_GID="$(id -u):$(id -g)" docker-compose up -d --build`
