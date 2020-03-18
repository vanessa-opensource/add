#!/bin/bash

set -x
set -e

ls -al ${HOME}/docker/
ls -al ${TRAVIS_BUILD_DIR}/build
dockerid=`docker images -a --filter=reference="onec32/client:${ONECVERSION}" --format '{{.ID}}'`
echo $dockerid
if [[ -f ${HOME}/docker/onec32_client_${ONECVERSION}.tar.xz ]]; then
    echo "found"
else
    echo "${HOME}/docker/onec32_client_${ONECVERSION}.tar.xz"
    if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
        wget -nv --continue -O ${HOME}/docker/onec32_client_${ONECVERSION}.tar.xz $URL_TARCLIENT
    fi
    if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
        wget -nv --continue -O ${HOME}/docker/onec32_client_${ONECVERSION}.tar.xz $URL_TARCLIENT
    fi
fi
if [[ -z $dockerid ]]; then

    xz -d -c ${HOME}/docker/onec32_client_${ONECVERSION}.tar.xz | docker load
fi