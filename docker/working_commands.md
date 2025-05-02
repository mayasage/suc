# Successful Commands

## Docker Desktop Process Management

```shell
systemctl --user status docker-desktop
```

## Docker Login

```shell
# removed existing config file because it won't overwrite
# rm ~/.docker/config.json
sudo setfacl --modify user:kratikal:rw /var/run/docker.sock
docker login
```

## Link docker-cli with docker-desktop

```shell
# images show up in docker-desktop, but not in docker-cli
docker context ls
docker context use desktop-linux
# images now show up in docker-cli
```

## MySql

```shell
docker container run \
  --detach \
  --name=mysql \
  --publish 3306:3306 \
  -e MYSQL_RANDOM_ROOT_PASSWORD=yes \
  -e LOWER_CASE_TABLE_NAMES=1 \
  mysql
```

## MariaDb

```shell
docker container run \
  --detach \
  --name=mariadb \
  --publish 3306:3306 \
  -e MYSQL_RANDOM_ROOT_PASSWORD=yes \
  -e LOWER_CASE_TABLE_NAMES=1 \
  mariadb
```

## Quit Logs

```plaintext
Ctrl+\ sends SIGQUIT
```

## Don't kill Container

```plaintext
Ctrl+PQ
```

## Dangling/Unused Images

```shell
docker image prune # all danging
docker image prune -a # all unused
```

## Filtering Images

```shell
docker images --filter dangling=true # find dangling
docker images --filter dangling=false # find non-dangling

docker images --filter before=mariadb # created before mariadb locally
docker images --filter before=12e05d5da3c5 # created before mariadb locally

docker images --filter since=mariadb # created since mariadb locally
docker images --filter since=12e05d5da3c5 # created since mariadb locally

docker images --filter=reference="*:latest" # for everything else

# custom using go templates
docker images --format "{{.Repository}}: {{.Tag}}: {{.Size}}"

docker images --digests # view sha256 hashes
docker images --quiet # show only image IDs
```

## Search Images

```shell
docker search alpine --filter "is-official=true" --limit=100 # only Name-based
```

## History

```shell
docker history ubuntu:latest # Not all commands are shown
```

## Pull All

```shell
docker pull -a nigelpoulton/tu-demo # pull all images in the repo
```

## Build for another platform

```sh
# Check version
docker buildx version
# github.com/docker/buildx v0.11.2-desktop.5 f20ec1393426619870066baba9618cf999063886

# Create a builder
docker buildx create --driver=docker-container --name=container

# Build for other platforms and push to dockerhub
docker buildx build --builder=container \
  --platform=linux/amd64,linux/arm64,linux/arm/v7 \
  -t mayasage/ddd-book:ch8.1 \
  --push .
```

## Push In Private Repository

```sh
# Login to dockerhub and create a new private repository.
# (mayasage/private-book)

# Tag local image.
docker image tag mayasage/ddd-book:ch8.1 mayasage/private-book:ch8.1

# Push
docker push mayasage/private-book:ch8.1
```

## Docker Compose Commands

```sh
# Up
docker compose up -f x.yml --detach
# -f = provide compose file (defaults to compose.yml | compose.yaml)
# --detach = container won't shutdown if you press Ctrl + C.

# Purge
docker compose down --volumes --rmi all
# --volumes = delete all volumes
# --rmi all = remove all intermediate images
```

```sh
# Mount new volume
docker container run -it --name voltainer \
  --mount source=bizvol,target=/vol \
  alpine

# Write some data
echo "I promise to leave a review of the book on Amazon" > /vol/file1

# Remove container
docker rm voltainer -f

# Volume still exists
docker volume ls

# Data still exists
ls -l /var/lib/docker/volumes/bizvol/_data/
# C:\ProgramData\Docker\volumes\bizvol\_data on Windows
cat /var/lib/docker/volumes/bizvol/_data/file1

# Mount volume to new container
docker run -it \
  --name hellcat \
  --mount source=bizvol,target=/vol \
  alpine sh

# See data
cat /vol/file1
```

## Logging

```sh
# When docker service logs fail.
docker service ps --no-trunc ddd_redis
```
