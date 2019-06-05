#we user squash here to remove unwanted layers, which is an experimental feature
#{"experimental": true} > /etc/docker/daemon.json
DOCKER_BUILD_OPTIONS=--no-cache=false --squash
GOSU1_VERSION=1.11
SPAWN_AND_TAIL_VERSION=0.2
TAG_VERSION=1.1
TOMCAT9_VERSION=9.0.20

sync-tools: deps/gosu1 deps/spawn-and-tail1
	@echo "syncing gosu"
	@echo optionfactory-ubuntu18-openjdk11/deps | xargs -n 1 rsync -az deps/gosu-${GOSU1_VERSION}
	@echo "syncing ps1"
	@echo optionfactory-ubuntu18-openjdk11/deps | xargs -n 1 rsync -az install-ps1.sh
	@echo "syncing spawn-and-tail"
	@echo optionfactory-ubuntu18-openjdk11/deps | xargs -n 1 rsync -az install-spawn-and-tail.sh
	@echo optionfactory-ubuntu18-openjdk11/deps | xargs -n 1 rsync -az deps/spawn-and-tail-${SPAWN_AND_TAIL_VERSION}

deps/gosu1: deps/gosu-${GOSU1_VERSION}
deps/spawn-and-tail1: deps/spawn-and-tail-${SPAWN_AND_TAIL_VERSION}
deps/gosu-${GOSU1_VERSION}:
	curl -# -sSL -k https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64 -o deps/gosu-${GOSU1_VERSION}
	chmod +x deps/gosu-${GOSU1_VERSION}
deps/spawn-and-tail-${SPAWN_AND_TAIL_VERSION}:
	curl -# -j -k -L https://github.com/optionfactory/spawn-and-tail/releases/download/v${SPAWN_AND_TAIL_VERSION}/spawn-and-tail-linux-amd64 > deps/spawn-and-tail-${SPAWN_AND_TAIL_VERSION}
	chmod +x deps/spawn-and-tail-${SPAWN_AND_TAIL_VERSION}
deps/jdk-11:
	curl -# -j -k -L https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.3%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.3_7.tar.gz | tar xz -C deps
	mv deps/jdk-11* deps/jdk-11
deps/apache-tomcat-${TOMCAT9_VERSION}:
	curl -# -sSL -k http://it.apache.contactlab.it/tomcat/tomcat-9/v${TOMCAT9_VERSION}/bin/apache-tomcat-${TOMCAT9_VERSION}.tar.gz | tar xz -C deps
deps/tomcat9: deps/apache-tomcat-${TOMCAT9_VERSION}

sync-openjdk11: deps/jdk-11
	@echo "syncing openjdk 11"
	@mkdir -p optionfactory-ubuntu18-openjdk11/deps
	@echo optionfactory-ubuntu18-openjdk11/deps/ | xargs -n 1 rsync -az install-openjdk11.sh
	@echo optionfactory-ubuntu18-openjdk11/deps/ | xargs -n 1 rsync -az deps/jdk-11

sync-tomcat9: deps/tomcat9
	@echo "syncing tomcat 9"
	@echo optionfactory-ubuntu18-openjdk11-tomcat9/deps | xargs -n 1 rsync -az install-tomcat9.sh
	@echo optionfactory-ubuntu18-openjdk11-tomcat9/deps | xargs -n 1 rsync -az init-tomcat9.sh
	@echo optionfactory-ubuntu18-openjdk11-tomcat9/deps | xargs -n 1 rsync -az deps/apache-tomcat-${TOMCAT9_VERSION}

docker-optionfactory-ubuntu18-openjdk11: sync-tools sync-openjdk11
	docker build ${DOCKER_BUILD_OPTIONS} --tag=optionfactory/ubuntu18-openjdk11:${TAG_VERSION} optionfactory-ubuntu18-openjdk11
	docker tag optionfactory/ubuntu18-openjdk11:${TAG_VERSION} optionfactory/ubuntu18-openjdk11:latest
docker-optionfactory-ubuntu18-openjdk11-tomcat9: sync-tools sync-tomcat9
	docker build ${DOCKER_BUILD_OPTIONS} --tag=optionfactory/ubuntu18-openjdk11-tomcat9:${TAG_VERSION} optionfactory-ubuntu18-openjdk11-tomcat9
	docker tag optionfactory/ubuntu18-openjdk11-tomcat9:${TAG_VERSION} optionfactory/ubuntu18-openjdk11-tomcat9:latest
