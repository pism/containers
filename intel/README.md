### PISM container using Intel oneAPI compilers, MPI library and MKL

Uses PROJ, FFTW, GSL and UDUNITS from Ubuntu packages and builds HDF5,
NetCDF, PETSc and PISM from sources using Intel's C/C++ compilers.

Uses MKL as the BLAS/LAPACK implementation when building PETSc.

We should be able to use MKL instead of FFTW as well, but that would
require some minor changes to PISM's build system.
