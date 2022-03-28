#!/bin/bash

set -x
set -e
set -u

# Install NCAR ParallelIO in /opt/parallelio using parallel NetCDF and
# PnetCDF installed in /opt/netcdf and /opt/pnetcdf. Uses
# /var/tmp/build/parallelio as a build directory.

netcdf_prefix=/opt/netcdf
pnetcdf_prefix=/opt/pnetcdf

url=https://github.com/NCAR/ParallelIO.git
build=/var/tmp/build/parallelio
prefix=/opt/parallelio

rm -rf ${build}
mkdir -p ${build}/build ${build}/sources

git clone ${url} ${build}/sources

pushd ${build}/sources
git checkout -b 2_5_6 pio2_5_6
popd

pushd ${build}/build

CC=mpicc cmake \
  -DCMAKE_C_FLAGS="-fPIC" \
  -DCMAKE_INSTALL_PREFIX=${prefix} \
  -DNetCDF_PATH=${netcdf_prefix} \
  -DPnetCDF_PATH=${pnetcdf_prefix} \
  -DPIO_ENABLE_FORTRAN=0 \
  -DPIO_ENABLE_TIMING=0 \
  ${build}/sources

make install

popd
