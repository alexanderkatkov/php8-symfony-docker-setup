include .env

# GLOBALS -------------------
APP=app
DC=docker-compose
DOCKER=docker
ENV=dev
POSTGRES=postgres
TMP_INSTALL_FOLDER="./tmp-install"

# BASE COMMANDS -------------------
build:
	@${DC} build --parallel --no-cache --compress --force-rm --pull

build-quick:
	@${DC} build --parallel --compress

install:
	@${DC} up -d --build --remove-orphans
	@${MAKE} app-composer-install

restart:
	@${DC} restart

stop:
	@${DC} stop

stop-all:
	@${DOCKER} stop $$(${DOCKER} ps -a -q)

up:
	@${MAKE} stop-all
	@${DC} up -d --remove-orphans
	@clear

# HELPERS -------------------
check:
	@read -p "${Q}?" -n 1 -r; \
	if [[ ! $$REPLY =~ ^[Yy] ]]; \
	then \
		echo -e "\n########################## You need to confirm! ##########################"; \
		exit 1; \
	fi

# APP COMMANDS -------------------
app-cache-clear:
	@${MAKE} app-exec CMD="rm -rf var/cache"
	@${MAKE} app-exec CMD="php bin/console cache:clear --env=$(ENV)"
	@${MAKE} app-exec CMD="php bin/console doctrine:cache:clear-query --env=$(ENV)"

app-composer-remove:
	@${MAKE} app-exec CMD="composer remove $(package)"

app-composer-install:
	@${MAKE} app-exec CMD="composer install --no-scripts -o"

app-composer-require:
	@${MAKE} app-exec CMD="composer require $(package)"

app-composer-require-dev:
	@${MAKE} app-exec CMD="composer require --dev $(package)"

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
	@echo "Importing .gitignore file contents >>>>>>>"
	@cat "${TMP_INSTALL_FOLDER}/.gitignore" >> .gitignore
	@rm -f "${TMP_INSTALL_FOLDER}/.gitignore"
	@echo "Copying files >>>>>>>"
	@\cp -fR ${TMP_INSTALL_FOLDER}/. ./
	@echo "Removing TMP folder >>>>>>>"
	@rm -rf ${TMP_INSTALL_FOLDER}

app-db-create:
	@${MAKE} app-exec CMD="bin/console doctrine:database:create --if-not-exists --env=$(ENV)"

app-db-remove:
	@${MAKE} app-exec CMD="bin/console doctrine:database:drop --env=$(ENV) --force --if-exists"

app-exec:
	@${DOCKER} exec -it ${CONTAINER_PREFIX}.${APP} ${CMD}

app-lint:
	make app-lint-phpstan
	make app-lint-phpcs
	make app-lint-parallel

app-lint-phpstan:
	@${MAKE} app-exec CMD="vendor/bin/phpstan clear-result-cache"
	@${MAKE} app-exec CMD="vendor/bin/phpstan analyse -l 6 -c phpstan.neon --no-progress --memory-limit=512M --error-format=table src tests"

app-lint-parallel:
	@${MAKE} app-exec CMD="vendor/bin/parallel-lint --exclude ./bin/.phpunit --exclude vendor ."

app-lint-phpcs:
	@${MAKE} app-exec CMD="vendor/bin/phpcs --standard=phpcs.xml.dist"

app-migration-diff:
	@${MAKE} app-exec CMD="bin/console doctrine:cache:clear-query"
	@${MAKE} app-exec CMD="bin/console doctrine:migrations:diff -n"

app-migration-migrate:
	@${MAKE} app-exec CMD="bin/console doctrine:migrations:migrate -n --env=$(ENV) --allow-no-migration"

app-phpunit:
	@${MAKE} app-exec CMD="bin/phpunit tests --stop-on-failure"

app-schema-create:
	@${MAKE} app-exec CMD="bin/console doctrine:schema:create --env=$(ENV)"

app-schema-drop:
	@${MAKE} app-exec CMD="bin/console doctrine:schema:drop --env=$(ENV) --force --full-database"

app-schema-validate:
	@${MAKE} app-exec CMD="bin/console doctrine:schema:validate --env=$(ENV)"

app-sh:
	@${MAKE} app-exec CMD="/bin/sh"

app-test:
	@${MAKE} app-db-remove ENV=test
	@${MAKE} app-db-create ENV=test
	@${MAKE} app-migration-migrate ENV=test
	@${MAKE} app-phpunit

postgres-exec:
	@${DOCKER} exec -it ${CONTAINER_PREFIX}.${POSTGRES} ${CMD}

postgress-sh:
	@${MAKE} postgres-exec CMD="/bin/sh"
