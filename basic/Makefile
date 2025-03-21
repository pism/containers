TAG=ckhrulev/pism-basic

image: Dockerfile
	docker build -t ${TAG} -f $^ .

run: image
	docker run --rm -it \
		--entrypoint /bin/bash \
		${TAG}

pism.sif: pism.def prereq.sif runtime.sif
	apptainer build $@ pism.def

runtime.sif:
prereq.sif:

%.sif: %.def
	apptainer build $@ $^
