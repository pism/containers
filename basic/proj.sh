#!/bin/bash

set -e
set -u
set -x

# Install PROJ in ${prefix}

build_dir=${build_dir:-/tmp/build/proj}
prefix=${prefix:-/opt/proj}

mkdir -p ${build_dir}
cd ${build_dir}
version=9.4.1

curl -OL https://download.osgeo.org/proj/proj-${version}.tar.gz
rm -rf proj-${version}
tar xzf proj-${version}.tar.gz

cmake \
    -B ${build_dir} \
    -S ${build_dir}/proj-${version} \
    -DCMAKE_INSTALL_PREFIX=${prefix} \
    -DENABLE_TIFF=NO \
    -DENABLE_CURL=NO \
    -DBUILD_TESTING=NO \
    -DBUILD_PROJSYNC=NO \
  ;

make -j install
