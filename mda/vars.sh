#!/bin/bash

#export REGISTRY=harbor.cns.ubiwhere.com/5gzorro
export REGISTRY=registry.ubiwhere.com
#export REGISTRY=ubiwhere

export SERVICE='mda'

export BINARY="/usr/bin/python3.9"

export IMAGE="mda"

export PREDECESSOR_FILE=predecessor.log

CURRENT_TAG=0
if [ -f TAG.txt ]; then
	CURRENT_TAG=$(cat TAG.txt)
fi
NEW_TAG=$((${CURRENT_TAG} + 1))
echo $NEW_TAG > TAG.txt
export TAG=1.0.${NEW_TAG}

echo $SERVICE $BINARY "->" $REGISTRY"/"$IMAGE":"$TAG
