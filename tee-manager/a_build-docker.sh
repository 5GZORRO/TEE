# Build TEE-Manager

#cd sources/Flask
docker build . -t "harbor.cns.ubiwhere.com/5gzorro/tee-manager:0.0.1"
docker --config ../docker push harbor.cns.ubiwhere.com/5gzorro/tee-manager:0.0.1

docker build . -t "registry.cbr.ubiwhere.com/tee-manager:latest"
docker --config ../docker push registry.cbr.ubiwhere.com/tee-manager:latest

