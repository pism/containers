#!/bin/bash

# Install Open MPI in ${prefix}, using /var/tmp/build/ompi as the build
# directory.
#
# Run as
#
# prefix=/path/to/use openmpi.sh
#
# to install in a different location.

set -e
set -u
set -x

prefix=${prefix:-/opt/ompi}
build_dir=${build_dir:-/var/tmp/build/ompi}
version=${version:-4.0.5}

mkdir -p ${build_dir}

cd ${build_dir}
version_major=$(echo ${version} | grep -oE "^[[:digit:]]\.[[:digit:]]")
wget -nc https://download.open-mpi.org/release/open-mpi/v${version_major}/openmpi-${version}.tar.gz

rm -rf openmpi-${version}
tar xzf openmpi-${version}.tar.gz
cd openmpi-${version}

# We set "CFLAGS=-w" to disable warnings
./configure CFLAGS=-w \
            --prefix=${prefix} \
  ;

make -j 8
make install
