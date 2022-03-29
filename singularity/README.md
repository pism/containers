This directory contains definition files and scripts used to build a
Singularity container with PISM.

Run `make` to build this container (`pism.sif`).

The build process is split into several steps:

1. Install libraries needed to support network (InfiniBand) hardware
   (output: `openmpi/network.sif`).
2. Build Open MPI built using `openmpi/network.sif`
   (output: `openmpi/openmpi.sif`).
3. Install build tools needed by subsequent steps (output: `build.sif`).
4. Install PETSc (output: `petsc.sif`).
5. Install parallel I/O libraries (NetCDF, PnetCDF, NCAR ParallelIO)
   (output: `io.sif`)
6. Install PISM (output: `pism.sif`).

We use (old!) CentOS 7 as the base Linux distribution because we
currently need to use `glibc` that supports an ancient Linux kernel
(2.6.32).

To run PISM within this container, do one of:

1. To run on one node:

        singularity exec pism.sif mpirun -n XX pismr ...
        
2. To run on multiple nodes, install Open MPI (the container uses
   version 4.1.2, but any version since 3.0.3 should work), then
   
        mpirun -n XX --hostfile YY singularity exec pism.sif pismr ...
        


        
