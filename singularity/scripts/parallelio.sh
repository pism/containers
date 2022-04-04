#!/bin/bash

set -x
set -e
set -u

# Install NCAR ParallelIO in /opt/parallelio using parallel NetCDF and
# PnetCDF installed in /opt/netcdf and /opt/pnetcdf. Uses
# /var/tmp/build/parallelio as a build directory.

MPICC=${MPICC:-mpicc}

netcdf_prefix=${netcdf_prefix:-/opt/netcdf}
pnetcdf_prefix=${pnetcdf_prefix:-/opt/pnetcdf}

url=https://github.com/NCAR/ParallelIO.git
build_dir=${build_dir:-/var/tmp/build/parallelio}
prefix=${prefix:-/opt/parallelio}

rm -rf ${build_dir}
mkdir -p ${build_dir}/build ${build_dir}/sources

git clone ${url} ${build_dir}/sources

pushd ${build_dir}/sources
git checkout -b 2_5_6 pio2_5_6
popd

pushd ${build_dir}/build

CC="${MPICC}" cmake \
  -DCMAKE_C_FLAGS="-fPIC" \
  -DCMAKE_INSTALL_PREFIX=${prefix} \
  -DNetCDF_PATH=${netcdf_prefix} \
  -DPnetCDF_PATH=${pnetcdf_prefix} \
  -DPIO_ENABLE_FORTRAN=0 \
  -DPIO_ENABLE_TIMING=0 \
  ${build_dir}/sources

make install

popd
