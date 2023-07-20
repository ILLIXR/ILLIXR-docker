#!/bin/bash
set -e

adduser --disabled-password --gecos '' ${USER}
echo "${USER}:${PASSWORD}" | chpasswd
echo 'PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/home/illixr/bin"' >> /home/${USER}/.profile
echo 'LD_LIBRARY_PATH="/home/illixr/lib"' >> /home/${USER}/.profile

mkdir -p /etc/sudoers.d/
echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
