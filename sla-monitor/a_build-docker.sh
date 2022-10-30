# Build
./vars.sh

#docker build . -t "harbor.cns.ubiwhere.com/5gzorro/${IMAGE}:${TAG}"
#docker build . -t "${REGISTRY}/${IMAGE}:${TAG}"
docker build . -t "${REGISTRY}/${IMAGE}:${TAG}" -f Dockerfile-secure

#docker --config ../docker push harbor.cns.ubiwhere.com/5gzorro/${IMAGE}:${TAG}
docker --config ../docker push ${REGISTRY}/${IMAGE}:${TAG}

