
## This Makefile builds a Docker image for running PISM

TAG ?= ckhrulev/pism-basic
## Set TAG to your preferred Docker tag. Ex: TAG=my/pism-custom make image

image: Dockerfile ## Build the Docker image
	docker build -t ${TAG} -f $^ .

run: image ## Run a Docker container
	docker run --rm -it \
		--entrypoint /bin/bash \
		${TAG}

pism.sif: pism.def prereq.sif runtime.sif ## Build a SIF file (Singularity HPC)
	apptainer build $@ pism.def

runtime.sif:
prereq.sif:

%.sif: %.def
	apptainer build $@ $^


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
