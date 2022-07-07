kubectl create secret generic uw --from-file=.dockerconfigjson=${PWD}/docker/config.json --type=kubernetes.io/dockerconfigjson
