#!/usr/bin/env bash
# Exit on error.
set -e

TAG=latest
PREFIX=hbstarjason
NAME=pipeline-craft
CURRENT_DIR="$(cd $(dirname "${BASH_SOURCE}") && pwd -P)"

docker build -t $PREFIX/$NAME $CURRENT_DIR
docker push $PREFIX/$NAME
