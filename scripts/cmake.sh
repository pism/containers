#!/bin/bash

set -e
set -u
set -x

# Install CMake in /opt/cmake using /var/tmp/build/cmake as the build
# directory.

build_dir=${build_dir:-/var/tmp/build/cmake}
prefix=${prefix:-/opt/cmake}

mkdir -p ${build_dir}
cd ${build_dir}
version=3.22.1

# --no-check-certificate is needed on ancient Ubuntu because
# ca-certificates is old
wget -nc \
     https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
rm -rf cmake-${version}
tar xzf cmake-${version}.tar.gz

cd cmake-${version}

./configure --prefix=${prefix}

make -j8 all
make install
