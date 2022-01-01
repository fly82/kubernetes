#!/usr/bin/env bash

# build
export DOCKER_BUILDKIT=1

APP=${1:-eureka}
APP_VER=${2:-latest}

echo -e "Building ${APP} ver ${APP_VER}"
docker build --tag ${APP}:${APP_VER} -f ./Dockerfile --no-cache .
docker image prune -f

# deploy
kubectl replace --force -f eureka/
