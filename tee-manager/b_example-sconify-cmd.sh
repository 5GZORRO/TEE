#REGISTRY=harbor.cns.ubiwhere.com/5gzorro
REGISTRY=registry.cbr.ubiwhere.com

docker run --rm --device="/dev/isgx" \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${PWD}/../docker/config.json:/root/.docker/config.json \
-v ${PWD}/sconification/build-resources:/build-resources \
-v ${PWD}/sconification/helm:/sconify-helm \
-v ${PWD}/../cas/:/root/.cas/ \
registry.scontain.com:5050/sconecuratedimages/community-edition-sconify-image:latest \
sconify_image --name=tee-manager \
--from=${REGISTRY}/tee-manager \
--to=${REGISTRY}/tee-manager-encrypted:latest \
--cas=5-7-0.scone-cas.cf \
--cli=registry.scontain.com:5050/sconecuratedimages/sconecli:sconify-image \
--cas-debug  \
--binary="/usr/bin/python3.9" -v \
--disable-session-upload --allow-debug-mode --allow-tcb-vulnerabilities \
--service-name="tee-manager" --name="tee-manager" \
--namespace="SDJLFSeer9w-UW-ZORRO" \
--k8s-helm-workload-type=deployment \
--identity="/root/.cas/config.json" \
--k8s-helm-set="useSGXDevPlugin=disabled" \
--k8s-helm-set="scone.log=DEBUG" \
--k8s-helm-set="imagePullSecrets[0].name=uw" \
--k8s-helm-set="imagePullPolicy=IfNotPresent" \
--push-image \
--plain="/tee-manager" \
-x --dlopen=2 --stack=4M --heap=1G

#-v --plain-file="/code/app.py" \


