FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

# Run time env variables
# env vars for the NVIDIA driver
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute,display

# Build time env variables
ARG DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
        # Dependencies: glvnd, x11, and OpenGL (dev)
        libx11-6 \
        libglvnd0 \
        libgl1 \
        libglx0 \
        libegl1 \
        libxext6 \
        libglvnd-dev \
        libgl1-mesa-dev \
        libegl1-mesa-dev \
        # Building tools
        build-essential \
        apt-utils \
        ca-certificates \
        libssl-dev \
        wget \
        git \
        curl \
        unzip \
        locales \
        sudo \
        rsync \
        clang-10 \
        gdb \
	    glmark2 && \
    # Fix clang linking
    ln -s $(which ${CC}) ${prefix_dir}/bin/clang && \
    ln -s $(which ${CXX}) ${prefix_dir}/bin/clang++ && \
    # Install latest CMake from source
    git clone --depth 1 https://github.com/Kitware/CMake /tmp/cmake && \
    cd /tmp/cmake && \
    ./bootstrap && \
    make -j"$(($(nproc) + 1))" install && \
    # Clean up
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    # Configure locale
    sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
    && locale-gen

# Install ILLIXR

ARG USER
ARG PASSWORD
ARG opt_dir=/opt/ILLIXR

# Set workdir to ILLIXR root
WORKDIR ${opt_dir}

# Create user
COPY create_user.sh /usr/local/bin/create_user.sh
RUN chmod +x /usr/local/bin/create_user.sh && \
    /usr/local/bin/create_user.sh && \
    rm /usr/local/bin/create_user.sh && \
    git clone --depth=1 https://github.com/ILLIXR/ILLIXR.git ${opt_dir} && \
    chown ${USER} ${opt_dir} -R

USER ${USER}

# Load variables
RUN ./deps.sh && \
    ./scripts/default_values.sh && \
    ./scripts/system_utils.sh

# Install dependencies
RUN sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ./scripts/install_apt_deps.sh && \
    sudo apt-get clean && \
    sudo apt-get autoremove && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/*

ARG CC=clang-10
ARG CXX=clang++-10
ARG prefix_dir=/usr/local
ARG illixr_nproc
ARG build_type=Release
ARG src_dir_conda=${opt_dir}/miniconda3
ARG env_config_path=runner/environment.yml

RUN ./scripts/install_opencv.sh
RUN ./scripts/install_vulkan_headers.sh
RUN ./scripts/install_gtest.sh
RUN ./scripts/install_openxr.sh
RUN ./scripts/install_gtsam.sh
RUN ./scripts/install_opengv.sh
RUN ./scripts/install_dbow2.sh
RUN ./scripts/install_kimera_rpgo.sh
RUN ./scripts/install_conda.sh
RUN sudo ldconfig
RUN ${src_dir_conda}/bin/conda env create --force -f ${env_config_path} && \
    ${src_dir_conda}/bin/conda init bash

# Install Vulkan
USER root
RUN apt-get update && \
    apt-get install vulkan-utils vulkan-tools \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json

# RUN git clone --depth=1 https://github.com/KhronosGroup/Vulkan-ValidationLayers.git /tmp/vulkan && \
#     cd /tmp/vulkan && \
#     mkdir build && \
#     cd ./build && \
#     ../scripts/update_deps.py && \
#     cmake -C helper.cmake -DCMAKE_BUILD_TYPE=Release .. && \
#     cmake --build . && \
#     sudo make install && \
#     sudo ldconfig && \
#     rm /tmp/vulkan


CMD tail -f /dev/null
