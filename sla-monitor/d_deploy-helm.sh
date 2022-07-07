cd sconification/helm/${SERVICE}

SERVICE_NAME=${SERVICE//_/-}
echo ${SERVICE_NAME}
helm -n scone get all ${SERVICE_NAME}
if [ $? -eq 0 ]; then
	echo "Installed"
	helm -n scone uninstall ${SERVICE_NAME}
else
	echo "${SERVICE} Not Installed"
fi

#helm -n scone uninstall ${SERVICE}
helm -n scone install -f values.yaml ${SERVICE_NAME} .
cd -
