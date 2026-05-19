docker: docker_build docker_run
docker_build:
	docker build -t sst_14_1 .

docker_build_15:
	docker build --build-arg SSTver=15.1.2 --build-arg SSTelemsVer=15.1.0 -t sst_15_1 .

docker_run:
	docker run -it --rm \
             -v `pwd`:/scratch \
             --user $(id -u):$(id -g) \
             sst_14_1 /bin/bash

docker_run_15:
	docker run -it --rm \
             -v `pwd`:/scratch \
             --user $(id -u):$(id -g) \
             sst_15_1 /bin/bash
