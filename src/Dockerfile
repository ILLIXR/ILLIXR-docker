FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

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
ARG illixr_dir=/opt/ILLIXR
ARG install_tmp_dir=/opt/ILLIXR_install

ARG CC=clang-10
ARG CXX=clang++-10
ARG build_type=Release
ARG src_dir_conda=${illixr_dir}/miniconda3
ARG env_config_path=runner/environment.yml

# Create user
COPY create_user.sh /usr/local/bin/create_user.sh
RUN chmod +x /usr/local/bin/create_user.sh && \
    /usr/local/bin/create_user.sh && \
    rm /usr/local/bin/create_user.sh && \
    # Create directories for ILLIXR
    mkdir ${illixr_dir} && \
    mkdir ${install_tmp_dir}

# Set workdir to installation root
WORKDIR ${install_tmp_dir}

# Copy variables
COPY ./ILLIXR/deps.sh ${install_tmp_dir}/deps.sh
COPY ./ILLIXR/scripts/default_values.sh ${install_tmp_dir}/scripts/default_values.sh
COPY ./ILLIXR/scripts/system_utils.sh ${install_tmp_dir}/scripts/system_utils.sh

# Copy ILLXIR package scripts
COPY ./ILLIXR/scripts/install_apt_deps.sh ${install_tmp_dir}/scripts/install_apt_deps.sh
COPY ./ILLIXR/scripts/install_opencv.sh ${install_tmp_dir}/scripts/install_opencv.sh
COPY ./ILLIXR/scripts/install_vulkan_headers.sh ${install_tmp_dir}/scripts/install_vulkan_headers.sh
COPY ./ILLIXR/scripts/install_gtest.sh ${install_tmp_dir}/scripts/install_gtest.sh
COPY ./ILLIXR/scripts/install_openxr.sh ${install_tmp_dir}/scripts/install_openxr.sh
COPY ./ILLIXR/scripts/install_opengv.sh ${install_tmp_dir}/scripts/install_opengv.sh
COPY ./ILLIXR/scripts/install_gtsam.sh ${install_tmp_dir}/scripts/install_gtsam.sh
COPY ./ILLIXR/scripts/install_dbow2.sh ${install_tmp_dir}/scripts/install_dbow2.sh
COPY ./ILLIXR/scripts/install_kimera_rpgo.sh ${install_tmp_dir}/scripts/install_kimera_rpgo.sh
COPY ./ILLIXR/scripts/install_conda.sh ${install_tmp_dir}/scripts/install_conda.sh

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
        vulkan-utils \
        vulkan-tools \
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
	vim \
	glmark2 \
        tzdata && \

    # Install cmake from Kitware repo
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install -qq -y --no-install-recommends cmake

# Insall ILLIXR dependencies
RUN ./scripts/install_apt_deps.sh && \

    # Fix clang linking
    ln -s $(which ${CC}) ${prefix_dir}/bin/clang && \
    ln -s $(which ${CXX}) ${prefix_dir}/bin/clang++ && \

    # Clean up
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    
    # Configure locale
    sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
    && locale-gen

# Install Nvidia config for Vulkan loader
COPY nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json

RUN ./scripts/install_opencv.sh && \
    ./scripts/install_vulkan_headers.sh && \
    ./scripts/install_gtest.sh && \
    ./scripts/install_openxr.sh && \
    ./scripts/install_gtsam.sh && \
    ./scripts/install_opengv.sh && \
    ./scripts/install_dbow2.sh && \
    ./scripts/install_kimera_rpgo.sh && \
    ./scripts/install_conda.sh && \
    sudo ldconfig && \
    sudo rm -rf ${install_tmp_dir} && \
    sudo chown -R illixr ${illixr_dir}

# ILLIXR source should be copied last to maximize cache utilization
COPY ./ILLIXR/ ${illixr_dir}

# Correct permissions for user switch
RUN chown illixr ${illixr_dir} && \
    chown illixr ${install_tmp_dir}

USER ${USER}

WORKDIR ${illixr_dir}
RUN ${src_dir_conda}/bin/conda env create --force -f ${env_config_path} && \
    ${src_dir_conda}/bin/conda init bash

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
