#!/bin/bash
# this script builds a full version of illixr

cd ILLIXR
rm -rf build
mkdir build
cd build
cmake .. -DYAML_FILE=/home/illixr/ILLIXR/profiles/ci.yaml -DCMAKE_INSTALL_PREFIX=/home/illixr
cmake --build . -- -j4
cmake --install .

main.opt.exe -yaml=/home/illixr/ILLIXR/illixr.yaml
