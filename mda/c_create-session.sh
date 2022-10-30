# copy session file
cp sconification/build-resources/session.yml ../cas/session_${SERVICE}.yaml

# add predecessor hash to the session file
if test -f "${PREDECESSOR_FILE}"; then
	value=`cat ${PREDECESSOR_FILE}`
	echo "predecessor: " ${value}
	#echo "predecessor:"${value} >> ../cas/session_${SERVICE}.yaml
	echo -e "\npredecessor: "${value} >> ../cas/session_${SERVICE}.yaml

	cp --backup=numbered ${PREDECESSOR_FILE} ${PREDECESSOR_FILE}.bak
fi

# create the session using SCONE CLI

docker run -v ${PWD}/../cas/:/root/.cas/ -it registry.scontain.com:5050/sconecuratedimages/sconecli:latest scone session create /root/.cas/session_${SERVICE}.yaml > ${PREDECESSOR_FILE}
echo -e "predecessor: "
cat ${PREDECESSOR_FILE}

echo ""
