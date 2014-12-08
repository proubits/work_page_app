#/bin/env bash

# Builds the docker image and pushs to
# repository (local by default)

# Usage:
#   build_and_push <directory of Dockerfile> <resultant docker image name>
#https://gist.githubusercontent.com/philwhln/8196116/raw/28eafd5cd1413d155d0f0c62f7261e385bbb393d/build_and_push.sh

DOCKERFILE_DIRECTORY=$1
DOCKER_IMAGE_NAME=$2

if [ "$DOCKER_REPO_SERVER" = "" ]; then
  DOCKER_REPO_SERVER=localhost:5000
fi
DOCKER_REPO_NAME=$DOCKER_REPO_SERVER/$DOCKER_IMAGE_NAME

# Build docker image
rm -f docker-built-id
docker build $DOCKERFILE_DIRECTORY \
  | perl -pe '/Successfully built (\S+)/ && `echo -n $1 > docker-built-id`'
if [ ! -f docker-built-id ]; then
  echo "No docker-built-id file found"
  exit 1
fi
DOCKER_BUILD_ID=`cat docker-built-id`
rm -f docker-built-id

# Publish built docker image to repo
docker tag $DOCKER_BUILD_ID $DOCKER_REPO_NAME
docker push $DOCKER_REPO_NAME
