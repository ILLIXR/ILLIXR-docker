FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

# Run time env variables
# env vars for the NVIDIA driver
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute,display

# Build time env variables
ARG DEBIAN_FRONTEND=noninteractive
ARG illixr_nproc

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
	    glmark2 && \
    # Fix clang linking
    ln -s $(which ${CC}) ${prefix_dir}/bin/clang && \
    ln -s $(which ${CXX}) ${prefix_dir}/bin/clang++ && \
    # Install latest CMake from source
    git clone --depth 1 https://github.com/Kitware/CMake /tmp/cmake && \
    cd /tmp/cmake && \
    ./bootstrap && \
    make -j${illixr_nproc} install && \
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

# Install ILLIXR

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
    chown illixr ${illixr_dir} && \
    mkdir ${install_tmp_dir} && \
    chown illixr ${install_tmp_dir}

USER ${USER}

# Set workdir to installation root
WORKDIR ${install_tmp_dir}

# Copy variables
COPY ./ILLIXR/deps.sh ${install_tmp_dir}/deps.sh
COPY ./ILLIXR/scripts/default_values.sh ${install_tmp_dir}/scripts/default_values.sh
COPY ./ILLIXR/scripts/system_utils.sh ${install_tmp_dir}/scripts/system_utils.sh

# Install dependencies
COPY ./ILLIXR/scripts/install_apt_deps.sh ${install_tmp_dir}/scripts/install_apt_deps.sh
RUN sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ./scripts/install_apt_deps.sh && \
    sudo apt-get clean && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/*

COPY ./ILLIXR/scripts/install_opencv.sh ${install_tmp_dir}/scripts/install_opencv.sh
RUN ./scripts/install_opencv.sh

COPY ./ILLIXR/scripts/install_vulkan_headers.sh ${install_tmp_dir}/scripts/install_vulkan_headers.sh
RUN ./scripts/install_vulkan_headers.sh

COPY ./ILLIXR/scripts/install_gtest.sh ${install_tmp_dir}/scripts/install_gtest.sh
RUN ./scripts/install_gtest.sh

COPY ./ILLIXR/scripts/install_openxr.sh ${install_tmp_dir}/scripts/install_openxr.sh
RUN ./scripts/install_openxr.sh

COPY ./ILLIXR/scripts/install_gtsam.sh ${install_tmp_dir}/scripts/install_gtsam.sh
RUN ./scripts/install_gtsam.sh

COPY ./ILLIXR/scripts/install_opengv.sh ${install_tmp_dir}/scripts/install_opengv.sh
RUN ./scripts/install_opengv.sh

COPY ./ILLIXR/scripts/install_dbow2.sh ${install_tmp_dir}/scripts/install_dbow2.sh
RUN ./scripts/install_dbow2.sh

COPY ./ILLIXR/scripts/install_kimera_rpgo.sh ${install_tmp_dir}/scripts/install_kimera_rpgo.sh
RUN ./scripts/install_kimera_rpgo.sh

COPY ./ILLIXR/scripts/install_conda.sh ${install_tmp_dir}/scripts/install_conda.sh
RUN ./scripts/install_conda.sh && \
    sudo ldconfig

COPY ./ILLIXR/ ${illixr_dir}

RUN sudo rm -rf ${install_tmp_dir} && \
    sudo chown -R illixr ${illixr_dir}

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
