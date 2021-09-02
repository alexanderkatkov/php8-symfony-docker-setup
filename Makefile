include .env

# GLOBALS -------------------
APP=app
DC=docker-compose
DOCKER=docker
EXEC=exec -it
TMP_INSTALL_FOLDER="./tmp-install"

# BASE COMMANDS -------------------
build:
	@${DC} build --parallel --no-cache --compress --force-rm --pull

build-quick:
	@${DC} build --parallel --compress

install:
	@${DC} up -d --build --remove-orphans

stop:
	@${DC} stop

stop-all:
	@${DOCKER} stop $$(${DOCKER} ps -a -q)

up:
	@${MAKE} stop-all
	@${DC} up -d --remove-orphans
	@clear

check:
	@read -p "${Q}?" -n 1 -r; \
	if [[ ! $$REPLY =~ ^[Yy] ]]; \
	then \
		echo -e "\n########################## You need to confirm! ##########################"; \
		exit 1; \
	fi

# APP COMMANDS -------------------
app-sh:
	@${DOCKER} ${EXEC} ${CONTAINER_PREFIX}.${APP} /bin/sh

app-create-skeleton:
	@clear
	@${MAKE} check Q="It will create new project and override existing base files! Are you sure"
	@echo "Deleting TMP folder if exists >>>>>>>"
	@rm -rf ${TMP_INSTALL_FOLDER}
	@echo "Creating new TMP folder >>>>>>>"
	@mkdir ${TMP_INSTALL_FOLDER}
	@echo "Downloading Symfony cache >>>>>>>"
	@${MAKE} app-exec CMD="composer create-project symfony/skeleton ./${TMP_INSTALL_FOLDER}"
	@echo "Importing ENV file contents >>>>>>>"
	@cat "${TMP_INSTALL_FOLDER}/.env" >> .env
	@rm -f "${TMP_INSTALL_FOLDER}/.env"
	@#rm -rf ${TMP_INSTALL_FOLDER}


app-exec:
	@${DOCKER} exec -it ${CONTAINER_PREFIX}.${APP} ${CMD}
