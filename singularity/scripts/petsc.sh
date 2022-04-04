#!/bin/bash

set -e
set -u
set -x

# Install PETSc in /opt/petsc using /var/tmp/build/petsc as the build
# directory.

MPICC=${MPICC:-mpicc}
MPICXX=${MPICXX:-mpicxx}

build_dir=${build_dir:-/var/tmp/build/petsc}
prefix=${prefix:-/opt/petsc}

mkdir -p ${build_dir}
cd ${build_dir}
version=3.17.0

wget -nc \
     https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz
rm -rf petsc-${version}
tar xzf petsc-${version}.tar.gz

cd petsc-${version}

PETSC_DIR=$PWD
PETSC_ARCH="linux-opt"

python3 ./configure \
        COPTFLAGS='-O3 -mavx2' \
        --prefix=${prefix} \
        --with-cc="${MPICC}" \
        --with-cxx="${MPICXX}" \
        --with-fc=0 \
        --with-shared-libraries \
        --with-debugging=0 \
        --download-f2cblaslapack

make all
make install
make PETSC_DIR=${prefix} PETSC_ARCH="" check
