#!/bin/bash

set -e
set -u
set -x

# Install SQLite in /opt/sqlite using /var/tmp/build/sqlite as the build
# directory.

build_dir=${build_dir:-/var/tmp/build/sqlite}
prefix=${prefix:-/opt/sqlite}

mkdir -p ${build_dir}
cd ${build_dir}
version=3380200

# --no-check-certificate is needed on ancient Ubuntu because
# ca-certificates is old
wget -nc \
     https://sqlite.org/2022/sqlite-autoconf-${version}.tar.gz
rm -rf sqlite-autoconf-${version}
tar xzf sqlite-autoconf-${version}.tar.gz

cd sqlite-autoconf-${version}

./configure --prefix=${prefix}

make -j8 all
make install
