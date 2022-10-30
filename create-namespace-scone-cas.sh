#!/bin/sh

# Get variables in https://sconedocs.github.io/public-CAS/
PUBLIC_CAS_ADDR=5-7-0.scone-cas.cf
PUBLIC_CAS_MRENCLAVE=3061b9feb7fa67f3815336a085f629a13f04b0a1667c93b14ff35581dc8271e4

echo "Create session"
docker run -v ${PWD}/cas/:/root/.cas/ -it registry.scontain.com:5050/sconecuratedimages/sconecli:latest scone cas attest $PUBLIC_CAS_ADDR $PUBLIC_CAS_MRENCLAVE -GCS --only_for_testing-debug --only_for_testing-ignore-signer

echo "Create namespace"
docker run -v ${PWD}/cas/:/root/.cas/ -it registry.scontain.com:5050/sconecuratedimages/sconecli:latest scone session create /root/.cas/namespace-sess.yaml > create-namespace-scone-cas.log
