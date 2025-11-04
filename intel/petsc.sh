#!/bin/bash

. /opt/intel/oneapi/setvars.sh

set -e
set -u
set -x

prefix=${prefix:-/opt/petsc}
build_dir=${build_dir:-/var/tmp/build/petsc}

optimization_flags="-O3 -axCORE-AVX2 -xSSE4.2 -fp-model=precise"

rm -rf ${build_dir}
mkdir -p ${build_dir}
cd ${build_dir}

git clone --depth=1 -b v3.24.0 https://gitlab.com/petsc/petsc.git .

./config/configure.py \
  --prefix=${prefix} \
  --with-cc=mpiicx \
  --with-fc=mpiifx \
  --with-cxx=mpiicx \
  --COPTFLAGS="${optimization_flags}" \
  --CXXOPTFLAGS="${optimization_flags}" \
  --FOPTFLAGS="${optimization_flags}" \
  --with-debugging=0 \
  --with-valgrind=0 \
  --with-x=0 \
  --with-ssl=0 \
  --download-mumps \
  --download-scalapack \
  --with-shared-libraries=1 \
  --with-blaslapack-dir=${MKLROOT}  | tee petsc-configure.log

make all && make install
