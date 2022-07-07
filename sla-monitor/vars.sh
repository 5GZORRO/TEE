#!/bin/bash

#export REGISTRY=harbor.cns.ubiwhere.com/5gzorro
export REGISTRY=registry.cbr.ubiwhere.com

export SERVICE='sla_monitor'

export BINARY="/usr/local/bin/node"

export IMAGE="sla_monitor"

export PREDECESSOR_FILE=predecessor.log

CURRENT_TAG=$(cat TAG.txt)
NEW_TAG=$((${CURRENT_TAG} + 1))
echo $NEW_TAG > TAG.txt
export TAG=1.0.${NEW_TAG}

echo $SERVICE $BINARY "->" $REGISTRY"/"$IMAGE":"$TAG
