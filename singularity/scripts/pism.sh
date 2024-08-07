#!/bin/bash

set -x
set -e
set -u

version=${version:-v2.0.4}
opt_flags=${opt_flags:--mavx2}

# Compilers:
export MPICC=${MPICC:-mpicc}
export MPICXX=${MPICXX:-mpicxx}

# Prerequisites:
export PETSC_DIR=${PETSC_DIR:-/opt/petsc}
hdf5_prefix=${hdf5_prefix:-/opt/hdf5}
netcdf_prefix=${netcdf_prefix:-/opt/netcdf}
pnetcdf_prefix=${pnetcdf_prefix:-/opt/pnetcdf}
parallelio_prefix=${parallelio_prefix:-/opt/parallelio}
udunits_prefix=${udunits_prefix:-/opt/udunits}
proj_prefix=${proj_prefix:-/opt/proj}

# Installation prefix and build location:
prefix=${prefix:-/opt/pism}
build_dir=${build_dir:-/var/build/pism}

mkdir -p ${build_dir}

pushd ${build_dir}
git clone https://github.com/pism/pism.git . || git pull
git checkout -b version-${version} ${version}
rm -rf build
mkdir -p build
popd

CC="${MPICC}" CXX="${MPICXX}" cmake \
    -B ${build_dir}/build \
    -S ${build_dir} \
    -DCMAKE_CXX_FLAGS=${opt_flags} \
    -DCMAKE_C_FLAGS=${opt_flags} \
    -DCMAKE_FIND_ROOT_PATH="${hdf5_prefix};${netcdf_prefix};${pnetcdf_prefix};${parallelio_prefix};${udunits_prefix};${proj_prefix}" \
    -DCMAKE_INSTALL_PREFIX=${prefix} \
    -DPism_USE_PARALLEL_NETCDF4=YES \
    -DPism_USE_PIO=YES \
    -DPism_USE_PNETCDF=YES \
    -DPism_USE_PROJ=YES \
    ;

make -C ${build_dir}/build -j 8 install/strip
