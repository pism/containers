#!/bin/bash

set -x
set -e
set -u

version=${version:-2.1}
opt_flags=${opt_flags:--O3}

# Compilers:
export MPICC=${MPICC:-mpicc}
export MPICXX=${MPICXX:-mpicxx}

# Prerequisites:
petsc_prefix=${petsc_prefix:-/opt/petsc}
hdf5_prefix=${hdf5_prefix:-/opt/hdf5}
netcdf_prefix=${netcdf_prefix:-/opt/netcdf}

# Installation prefix and build location:
prefix=${prefix:-/opt/pism}
build_dir=${build_dir:-/var/build/pism}

mkdir -p ${build_dir}

cd ${build_dir}

wget -nc https://github.com/pism/pism/archive/refs/tags/v${version}.tar.gz
tar xzvf v${version}.tar.gz

rm -rf ${build_dir}/build
mkdir -p ${build_dir}/build

CC="${MPICC}" CXX="${MPICXX}" cmake \
    -B ${build_dir}/build \
    -S ${build_dir}/pism-${version} \
    -DCMAKE_CXX_FLAGS="${opt_flags}" \
    -DCMAKE_C_FLAGS="${opt_flags}" \
    -DCMAKE_PREFIX_PATH="${hdf5_prefix};${netcdf_prefix};${petsc_prefix}" \
    -DCMAKE_FIND_ROOT_PATH="${hdf5_prefix};${netcdf_prefix}" \
    -DCMAKE_INSTALL_PREFIX=${prefix} \
    -DPism_USE_PARALLEL_NETCDF4=YES \
    -DPism_USE_PROJ=YES \
    ;

make -C ${build_dir}/build -j 8 install/strip
