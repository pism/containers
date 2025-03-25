TAG=ckhrulev/pism-basic

image: Dockerfile
	docker build -t ${TAG} -f $^ .

run: image
	docker run --rm -it \
		--entrypoint /bin/bash \
		${TAG}

pism-31fabd4f.sif:

runtime.sif:
prereq.sif:

pism-prereq.sif: pism-prereq.def prereq.sif
	apptainer build -F $@ pism-prereq.def

pism-%.sif: pism.def pism-prereq.sif runtime.sif
	apptainer build -F --build-arg pism_version="$*" $@ pism.def

%.sif: %.def
	apptainer build -F $@ $^
