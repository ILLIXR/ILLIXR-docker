FROM hub.ncsa.illinois.edu/friedel/nvidia/cudagl:12.2.0-devel-ubuntu22.04

# Run time env variables
# env vars for the NVIDIA driver
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute,display

# Build time env variables
ARG DEBIAN_FRONTEND=noninteractive
ARG illixr_nproc

# Env var for ILLIXR installation
ARG USER
ARG PASSWORD
ARG illixr_dir=/home/illixr

ARG build_type=Debug

WORKDIR /home/illixr

# Create user
COPY create_user.sh /usr/local/bin/create_user.sh
RUN chmod +x /usr/local/bin/create_user.sh && \
    /usr/local/bin/create_user.sh && \
    rm /usr/local/bin/create_user.sh

# Install packages
RUN apt-get update && \
    apt-get install -y install \
    curl \
    apt-transport-https \
    lsb-core \
    libglew-dev \
    libglu1-mesa-dev \
    libsqlite3-dev \
    libx11-dev \
    libgl1-mesa-dev \
    git \
    libboost-all-dev \
    libeigen3-dev \
    glslang-dev \
    glslang-tools \
    libgflags-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    udev \
    libudev-dev \
    libwayland-dev \
    wayland-protocols \
    libx11-xcb-dev \
    libxcb-glx0-dev \
    libxcb-randr0-dev \
    libxkbcommon-dev \
    libopenxr-dev \
    libopenxr1-monado \
    libvulkan-dev \
    libsdl2-dev \
    cmake \
    g++ \
    extra-cmake-modules \
    libopencv-dev \
    libglfw3-dev \
    pkg-config \
    libusb-1.0.0-dev \
    patch \
    libfmt-dev \
    libgoogle-glog-dev \
    libssl-dev \
    libsdl2-dev \
    libprotobuf-dev \
    libprotoc-dev \
    protobuf-compiler \
    graphviz \
    zlib1g-dev \
    qtbase5-dev \
    libhdf5-dev \
    libcurl4-openssl-dev \
    libqwt-qt5-dev \
    libyaml-cpp-dev


# Install Nvidia config for Vulkan loader
COPY nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json

RUN sudo chown -R illixr ${illixr_dir}

# ILLIXR source should be copied last to maximize cache utilization
COPY ./ILLIXR/ ${illixr_dir}
COPY --chown=illixr cmk.sh ${illixr_dir}/bin
RUN chmod +x ${illixr_dir}/bin/cmk.sh
USER ${USER}

CMD tail -f /dev/null
