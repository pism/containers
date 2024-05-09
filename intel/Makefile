TAG=ckhrulev/pism-intel

run: image
	docker run --rm -it ${TAG} bash -l

image: Dockerfile
	docker build -t ${TAG} --target pism -f $^ .

image-runtime: Dockerfile
	docker build -t ${TAG}-runtime --target pism-runtime -f $^ .

run-runtime: image-runtime
	docker run --rm -it ${TAG}-runtime bash -l

image-devel: Dockerfile
	docker build -t ${TAG}-devel --target pism-prerequisite-libs -f $^ .

run-devel: image-devel
	docker run --rm -it ${TAG}-devel bash -l
