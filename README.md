
# Docker Compose and WordPress

This repository was forked from [v3nt/docker-wordpress-composer](https://github.com/v3nt/docker-wordpress-composer)

Use WordPress locally with Docker using [Docker compose](https://docs.docker.com/compose/)

+ `Dockerfile` for extending a base image and install wp-cli
	+ Using a custom [Docker image](https://github.com/urre/wordpress-nginx-docker-compose-image) with [automated build on Docker Hub](https://cloud.docker.com/repository/docker/urre/wordpress-nginx-docker-compose-image)
+ Local domain ex `myapp.local`
+ Custom nginx config in `./nginx`
+ Custom PHP `php.ini` config in `./config`
+ Volumes for `nginx`, `wordpress` and `mariadb`
+ WordPress using [Bedrock](https://roots.io/bedrock/) - modern development tools, easier configuration, and an improved folder structure
+ CLI scripts
	- Create a self signed SSL certificate for using https
	- Trust certs in macOS System Keychain
	- Setup the local domain in your in `/etc/hosts`
	- Create Containers
	- Install - Runs `composer update` Script to run composer inside docker machine and install WP inside of it running `composer install`
	- Destroy - Destroys and Delete all volumes and non-tracked PHP files
	- Up and Down scripts

## Setup

### Requirements

Install [Docker](https://www.docker.com/get-started)

### Create SSL cert

```shell
cd cli && ./create-cert.sh
```

> Edit the script to your your custom domain, this example uses myapp.local

### Trust the cert in macOS Keychain.

Chrome and Safari will trust the certs using this script.

> In Firefox: Select Advanced, Select the Encryption tab, Click View Certificates. Navigate to where you stored the certificate and click Open, Click Import.

```shell
cd cli && ./trust-cert.sh
```

> Edit the script to your your custom domain, this example uses myapp.local

### Setup vhost in /etc/hosts

```shell
cd cli && ./setup-hosts-file.sh
```
> Follow the instructions. For example use `myapp.local`

### Setup ENV for DockerFile

```shell
cp .env.example .env
```

### Setup ENV for WordPress settings

```shell
cd src
cp .env.example .env
```

Use the following database settings:

```yml
DB_HOST=mysql:3306
DB_NAME=myapp
DB_USER=myapp
DB_PASSWORD=password
```

**Important note:** if you change the ENV settings on the Dockerfile ENV, remember to set the same changes inside the `src` folder as well.

## Install WordPress and Composer dependencies

```shell
cd src
composer install
```

> You can also use composer like this: `docker-compose run composer update`
> Or, you can run `./cli/install.sh` to run this automatically

## Run

```shell
docker-compose up -d
```

> Or, you can run `./cli/up.sh` to run this automatically

🚀 Open up [https://myapp.local](https://myapp.local)

### Notes:

When making changes to the Dockerfile, use:

```bash
docker-compose up -d --force-recreate --build
```

> Or, even better, to force the recreation, run, in the following order:

```shell
cd cli && ./destroy.sh && ./recreate.sh && ./install.sh
```

> With those 3 commands you are removing every volume, images, rebuilding the machine and installing composer dependencies

### Tools

#### wp-cli examples
old. => new.

```shell
docker exec -it myapp-wordpress bash
wp search-replace https://olddomain.com https://myapp.local --allow-root
```

### Changelog

#### 2020-12-13
- Added cronjob so now the container doesn't depends on WP_Cron to run, the cron jobs are running trough wp-cli
- Added scripts to recreate, destroy, put the containers up and down and also to install composer dependencies
- Removed wp clone using curl on the original `urre/wordpress-nginx-docker-compose` Dockerfile. No use since it's composer that installs the wordpress using `roots/wordpress`
- Updated PHP to 8.2 and WordPress to 6.4
- Removed initial backups from the original repo
- Fixed Imagick and zip failing after cloning the Dockerfile script from `urre/wordpress-nginx-docker-compose`
- Added ENV variables for almost everything
- Removed the need of using the root user for WordPress Installation access to MariaDB
- Changed the Debug logging to a file instead of displaying errors in the browser

#### 2019-08-02
- Added Linux support. Thanks to [@faysal-ishtiaq](https://github.com/faysal-ishtiaq).

***

### Useful Docker Commands

Login to the docker container

```shell
docker exec -it myapp-wordpress bash
```

Stop

```shell
docker-compose stop
```

Down (stop and remove)

```shell
docker-compose down
```

Cleanup

```shell
docker-compose rm -v
```

Recreate

```shell
docker-compose up -d --force-recreate
```

Rebuild docker container when Dockerfile has changed

```shell
docker-compose up -d --force-recreate --build
```
