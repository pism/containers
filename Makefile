all: pism.sif

openmpi.sif:
	${MAKE} -C openmpi
	ln -s openmpi/openmpi.sif .

pism.sif: petsc.sif io.sif scripts/pism.sh scripts/udunits2.sh

io.sif: build.sif scripts/hdf5.sh scripts/netcdf.sh scripts/pnetcdf.sh scripts/parallelio.sh

petsc.sif: build.sif scripts/petsc.sh

build.sif: openmpi.sif scripts/cmake.sh

%.sif: %.def
	singularity build --fakeroot --force $@ $<

.PHONY: clean
clean:
	@rm -f *.sif

INTERMEDIATE=io.sif petsc.sif build.sif openmpi.sif
#.INTERMEDIATE: ${INTERMEDIATE}
