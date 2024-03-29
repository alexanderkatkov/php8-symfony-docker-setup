# Local Setup for Symfony Development

This repository uses [Taskfile](https://taskfile.dev/) for shortcuts of common commands used in Symfony development.

## Features
 - HTTP2 support
 - Self-signed HTTPS for dev environment
 - PHP 8.1
 - Supervisor for PHP container
 - No file permissions issues

## Base setup includes these images
- php:8.1-fpm-alpine
- nginx:stable-alpine

## Hot to init new skeleton project
1) Adjust `CONTAINER_PREFIX` in ENV file: `CONTAINER_PREFIX=project_name`
2) Run command `task create-skeleton`, it will initialize new Symfony Skeleton project in project root folder.

## Static analyzers included
Dev tools can be installed using `task install-dev-base` command
- PHP_CodeSniffer
- PHPStan
- PHP-Parallel-Lint
- PHPUnit

### Default dev packages installed via command above
- symfony/maker-bundle
- symfony/test-pack
- phpstan/phpstan
- phpstan/extension-installer
- phpstan/phpstan-symfony
- phpstan/phpstan-phpunit
- phpstan/phpstan-doctrine
- squizlabs/php_codesniffer
- slevomat/coding-standard
- php-parallel-lint/php-parallel-lint

## Current Tasks List
| **Command**                           | **Description**                                                                                                                                                                                                                                                                                                                                                                                 |
|---------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `task app:cache-clear`                | Clear Symfony cache                                                                                                                                                                                                                                                                                                                                                                             |
| `task app:exec`                       | Runs any CLI command inside APP container: `task app:exec -- php -v`                                                                                                                                                                                                                                                                                                                            |
| `task app:sh`                         | SSH into APP container                                                                                                                                                                                                                                                                                                                                                                          |
| `task bin/console`                    | Symfony "bin/console" command shortcut: `task bin/console -- cache:clear`                                                                                                                                                                                                                                                                                                                       |
| `task composer:install`               | Install composer packages                                                                                                                                                                                                                                                                                                                                                                       |
| `task composer:remove`                | Remove composer package: `task composer:remove -- vendor/package`                                                                                                                                                                                                                                                                                                                               |
| `task composer:require`               | Add composer package. Use package as argument: `task app:composer-require -- vendor/package`                                                                                                                                                                                                                                                                                                    |
| `task composer:require-dev`           | Add composer package to dev section. Use package as argument: `task app:composer-require-dev -- vendor/package`                                                                                                                                                                                                                                                                                 |
| `task create-skeleton`                | Create empty Symfony Skeleton project                                                                                                                                                                                                                                                                                                                                                           |
| `task docker:build`                   | Builds images                                                                                                                                                                                                                                                                                                                                                                                   |
| `task docker:down`                    | Stop and delete containers in current directory                                                                                                                                                                                                                                                                                                                                                 |
| `task docker:rebuild`                 | Rebuild images, with pulling updates and removing old images                                                                                                                                                                                                                                                                                                                                    |
| `task docker:stop`                    | Stops containers in current directory                                                                                                                                                                                                                                                                                                                                                           |
| `task docker:stop-all`                | Stops all containers across the system                                                                                                                                                                                                                                                                                                                                                          |
| `task docker:up`                      | Stops all running containers and starts containers for current project                                                                                                                                                                                                                                                                                                                          |
| `task install-dev-base`               | Install base dev packages for a project:<br>   - `symfony/maker-bundle`<br>   - `symfony/test-pack`<br>   - `phpstan/phpstan`<br>   - `phpstan/extension-installer`<br>   - `phpstan/phpstan-symfony`<br>   - `phpstan/phpstan-phpunit`<br>   - `phpstan/phpstan-doctrine`<br>   - `squizlabs/php_codesniffer`<br>   - `slevomat/coding-standard`<br>   - `php-parallel-lint/php-parallel-lint` |
| `task lint`<br> `task lint:all`       | Run all linting tasks:<br>   - `PHP_CodeSniffer`<br>   - `PHPStan`<br>   - `PHP-Parallel-Lint`                                                                                                                                                                                                                                                                                                  |
| `task lint:parallel`                  | Run PHP-Parallel-Lint error checking                                                                                                                                                                                                                                                                                                                                                            |
| `task lint:phpcbf`                    | Run PHP Code Beautifier and Fixer                                                                                                                                                                                                                                                                                                                                                               |
| `task lint:phpcs`                     | Run PHP_CodeSniffer analyzer                                                                                                                                                                                                                                                                                                                                                                    |
| `task lint:phpstan`                   | Run PHPStan static analyzer                                                                                                                                                                                                                                                                                                                                                                     |
| `task phpunit`<br> `task phpunit:all` | Run all PHPUnit tests                                                                                                                                                                                                                                                                                                                                                                           |
| `task phpunit:single`                 | Filter result of single PHPUnit tests: `task phpunit:single -- testName`, also can be used with `TestClassName`                                                                                                                                                                                                                                                                                 |
|                                       |                                                                                                                                                                                                                                                                                                                                                                                                 |