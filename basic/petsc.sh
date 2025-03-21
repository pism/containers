#!/bin/bash

set -e
set -u
set -x

# Install the latest PETSc in ${prefix}

build_dir=${build_dir:-/tmp/build/petsc}

rm -rf ${build_dir}
mkdir -p ${build_dir}
cd ${build_dir}

git clone -b release --depth=1 https://gitlab.com/petsc/petsc.git .

prefix=${prefix:-/opt/petsc}
PETSC_DIR=$PWD
PETSC_ARCH="linux-opt"

./configure \
  COPTFLAGS="-g -O3" \
  --prefix=${prefix} \
  --with-cc=mpicc \
  --with-cxx=mpicxx \
  --with-fc=0 \
  --with-shared-libraries \
  --with-debugging=0 \
  --with-x=0 \
  --download-f2cblaslapack

make all
make install
make PETSC_DIR=${prefix} PETSC_ARCH="" check
