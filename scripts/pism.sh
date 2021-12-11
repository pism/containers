#!/bin/bash

set -x
set -e
set -u

prefix=${prefix:-/opt/pism}
build_dir=${build_dir:-/var/build/pism}
version=v2.0.2

mkdir -p ${build_dir}

pushd ${build_dir}
git clone https://github.com/pism/pism.git . || git pull
git checkout ${version}
rm -rf build
mkdir -p build
popd

export PETSC_DIR=/opt/petsc

CC=mpicc CXX=mpicxx cmake \
    -B ${build_dir}/build \
    -S ${build_dir} \
    -DCMAKE_CXX_FLAGS="-mavx2" \
    -DCMAKE_C_FLAGS="-mavx2" \
    -DCMAKE_FIND_ROOT_PATH="/opt/hdf5/;/opt/netcdf/;/opt/pnetcdf;/opt/parallelio;/opt/udunits" \
    -DCMAKE_INSTALL_PREFIX=${prefix} \
    -DPism_USE_PARALLEL_NETCDF4=YES \
    -DPism_USE_PIO=YES \
    -DPism_USE_PNETCDF=YES \
    -DPism_USE_PROJ=NO \
    ;

make -C ${build_dir}/build -j 8 install
