cd sconification/helm/tee-manager
helm -n scone uninstall tee-manager
helm -n scone install -f values.yaml tee-manager .
cd -
