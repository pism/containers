from ubuntu:24.04 as build
arg DEBIAN_FRONTEND=noninteractive
env PISM_PREFIX=/opt/pism

# Install PISM's build dependencies
run <<EOF
    echo "Install some build tools and dependencies"

    set -e
    set -u
    set -x

    apt-get update

    # ca-certificates and curl are needed to download sources
    # cmake, make, pkg-config are needed to build PISM
    # gfortran is needed to build YAXT and YAC
    # libfyaml is used by YAC
    # OpenMPI, FFTW, GSL, UDUNITS, NetCDF are used by PISM
    # git is used to get sources
    apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    curl \
    g++ \
    git \
    libfftw3-dev \
    libfyaml-dev \
    libgsl-dev \
    libnetcdf-dev \
    libopenmpi-dev \
    libtool \
    libudunits2-dev \
    libproj-dev \
    make \
    netcdf-bin \
    openmpi-bin \
    pkg-config \
    python3 \
    sqlite3 \
    ""

    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOF

copy yac.sh /tmp/
run <<EOF
    echo "Install YAC"

    set -e
    set -u
    set -x

    # Allow running MPI as root: YAXT's (and possibly YAC's configure
    # script needs to run some tests)
    export OMPI_ALLOW_RUN_AS_ROOT=1
    export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

    prefix=${PISM_PREFIX} build_dir=/tmp/build/yac /tmp/yac.sh
EOF

copy petsc.sh /tmp/
run <<EOF
    echo "Install PETSc"

    set -e
    set -u
    set -x

    # Allow running MPI as root to be able to run "make check" after building PETSc
    export OMPI_ALLOW_RUN_AS_ROOT=1
    export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

    prefix=${PISM_PREFIX} /tmp/petsc.sh
EOF

copy pism.sh /tmp/
arg pism_url
env pism_url=${pism_url}
arg pism_commit
env pism_commit=${pism_commit}
run <<EOF
    echo "Install PISM"

    set -e
    set -u
    set -x

    prefix=${PISM_PREFIX} build_dir=/tmp/build/pism lib_dir=${PISM_PREFIX} commit=${pism_commit} /tmp/pism.sh
EOF

run <<EOF
    echo "Clean up"
    rm ${PISM_PREFIX}/lib/*.a ${PISM_PREFIX}/lib/*.la
    strip ${PISM_PREFIX}/lib/*.so
    rm -rf ${PISM_PREFIX}/share/petsc/examples
    rm -rf ${PISM_PREFIX}/include/pism
EOF

from ubuntu:24.04 as runtime
arg DEBIAN_FRONTEND=noninteractive
# Unfortunately PISM_PREFIX variable defined near the top of this file
# went out of scope at the end of the first ("build") stage.
env PISM_PREFIX=/opt/pism

run <<EOF
    echo "Install runtime dependencies"

    set -e
    set -u
    set -x

    apt-get update

    # PISM's runtime dependencies
    apt-get install -y --no-install-recommends \
    libfftw3-double3 \
    libfyaml0 \
    libgsl27 \
    libnetcdf19t64 \
    libopenmpi3t64 \
    libproj25 \
    libudunits2-0 \
    openmpi-bin \
    ""

    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOF

copy --from=BUILD ${PISM_PREFIX} ${PISM_PREFIX}

# Add a non-privileged user to use OpenMPI
run useradd --create-home --system --shell=/bin/false worker && usermod --lock worker
user worker

# Add PISM to the PATH:
env PATH=${PISM_PREFIX}/bin:$PATH
