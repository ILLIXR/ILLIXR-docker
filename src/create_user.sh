#!/bin/bash
set -e

adduser --disabled-password --gecos '' ${USER}
echo "${USER}:${PASSWORD}" | chpasswd
echo 'PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin"' >> /home/${USER}/.profile

echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd