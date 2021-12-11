openmpi.sif: network.sif openmpi.sh mpi_hello.c

%.sif: %.def
	singularity build --fakeroot --force $@ $<

.PHONY: clean
clean:
	rm -f *.sif
