#!/bin/bash

set -x
set -e

dockerid=`docker images -a --filter=reference="onec32/client:${ONECVERSION}" --format '{{.ID}}'`
echo $dockerid
if [[ -z $dockerid ]]; then
wget -nv --continue -O - $URL_TARCLIENT | xz -d | docker load
fi