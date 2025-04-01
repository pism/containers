
## This Makefile builds a Docker and Apptainer images for running PISM

TAG = ckhrulev/pism-basic
## Set TAG to your preferred Docker tag. Ex: TAG=my/pism-custom make image

pism_url = https://github.com/pism/pism.git
pism_commit = dev

image: Dockerfile ## Build the Docker image
	docker build --build-arg pism_url=$(pism_url) --build-arg pism_commit=$(pism_commit) -t ${TAG} -f $^ .

run: image ## Run a Docker container
	docker run --rm -it \
		--entrypoint /bin/bash \
		${TAG}

pism-prereq.sif: pism-prereq.def prereq.sif
	apptainer build -F $@ pism-prereq.def

pism-v2.2.2.sif:

pism-%.sif: pism.def pism-prereq.sif runtime.sif ## Build a SIF file (Singularity HPC)
	apptainer build -F --build-arg pism_commit="$*" $@ pism.def

runtime.sif:
prereq.sif:

%.sif: %.def
	apptainer build -F $@ $^


.DEFAULT_GOAL := help
help: ## (Default) Print list of commented targets
	@printf "\nUsage: make <command>\n"
	@grep -F -h "##" $(MAKEFILE_LIST) | grep -F -v grep -F | sed -e 's/\\$$//' | awk 'BEGIN {FS = ":*[[:space:]]*##[[:space:]]*"}; \
	{ \
		if($$2 == "") \
			printf ""; \
		else if($$0 ~ /^#/) \
			printf "\n%s\n", $$2; \
		else if($$1 == "") \
			printf "     %-20s%s\n", "", $$2; \
		else \
			printf "\n    \033[34m%-20s\033[0m %s\n", $$1, $$2; \
	}'
