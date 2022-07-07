# copy session file
cp sconification/build-resources/session.yml ../cas/session_tee_manager.yaml

# add predecessor hash to the session file
value=`cat predecessor.log`
#echo "predecessor:"${value} >> ../cas/session_tee_manager.yaml
echo -e "\npredecessor: "${value} >> ../cas/session_tee_manager.yaml

# create the session using SCONE CLI
docker run -v ${PWD}/../cas/:/root/.cas/ -it registry.scontain.com:5050/sconecuratedimages/sconecli:latest scone session create /root/.cas/session_tee_manager.yaml > predecessor.log


