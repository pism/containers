#!/bin/bash

lib_dir=${lib_dir:-/opt/pism}
prefix=${prefix:-/opt/pism}
build_dir=${build_dir:-/tmp/build/pism}
commit=${commit:-main}
pism_url=${pism_url:-https://github.com/pism/pism.git}

set -e
set -u
set -x

opt_flags="-O3"

rm -rf ${build_dir}
mkdir -p ${build_dir}
cd ${build_dir}

git clone ${pism_url} pism-${commit}
cd pism-${commit}
git checkout -b branch-${commit} origin/${commit}

cmake -B ${build_dir} -S . \
      -DCMAKE_CXX_FLAGS="${opt_flags}" \
      -DCMAKE_C_FLAGS="${opt_flags}" \
      -DCMAKE_INSTALL_PREFIX="${prefix}" \
      -DCMAKE_PREFIX_PATH="${lib_dir}" \
      -DPism_USE_PROJ=YES \
      -DPism_USE_YAC_INTERPOLATION=YES

make -j -C ${build_dir} install/strip
