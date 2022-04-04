#!/bin/bash

set -e
set -u
set -x

# Install PnetCDF 1.12.1 in /opt/pnetcdf, using /var/tmp/build/pnetcdf as
# the build directory.

MPICC=${MPICC:-mpicc}

version=1.12.1
prefix=${prefix:-/opt/pnetcdf}
build_dir=${build_dir:-/var/tmp/build/pnetcdf/}
url=https://parallel-netcdf.github.io/Release/pnetcdf-${version}.tar.gz

mkdir -p ${build_dir}
cd ${build_dir}

wget -nc ${url}
rm -rf pnetcdf-${version}
tar xzf pnetcdf-${version}.tar.gz

cd pnetcdf-${version}

./configure CC="${MPICC}" \
      --prefix=${prefix} \
      --enable-shared \
      --disable-static \
      --disable-cxx \
      --disable-fortran

make all
make install
