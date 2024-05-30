TAG=ckhrulev/pism-intel

run: image
	docker run --rm -it ${TAG}

image: Dockerfile
	docker build -t ${TAG} --target pism -f $^ .

image-runtime: Dockerfile
	docker build -t ${TAG}-runtime --target pism-runtime -f $^ .

run-%: image-%
	docker run --rm -it ${TAG}-$*

image-devel: Dockerfile
	docker build -t ${TAG}-devel --target pism-prerequisite-libs -f $^ .
