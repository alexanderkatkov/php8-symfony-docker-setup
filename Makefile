include .env

# GLOBALS -------------------
APP=app
DC=docker-compose
DOCKER=docker
EXEC=exec -it
TMP_INSTALL_FOLDER='./tmp-install'

# BASE COMMANDS -------------------
build:
	${DC} build --parallel --no-cache --compress --force-rm --pull

build-quick:
	${DC} build --parallel --compress

install:
	${DC} up -d --build --remove-orphans

stop:
	${DC} stop

stop-all:
	${DOCKER} stop $$(${DOCKER} ps -a -q)

up:
	${MAKE} stop-all
	${DC} up -d --remove-orphans
	clear

# APP COMMANDS -------------------
app-sh:
	${DOCKER} ${EXEC} ${CONTAINER_PREFIX}.${APP} /bin/sh

app-create-skeleton:
	clear
	rm -rf ${TMP_INSTALL_FOLDER}
	mkdir ${TMP_INSTALL_FOLDER}
	#${MAKE} app-exec

app-exec:
	${DOCKER} exec -it ${CONTAINER_PREFIX}.${APP} ${CMD}
