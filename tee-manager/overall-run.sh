echo "0. If necessary, create the necessary Docker folder and Secret"
#../generate-docker-folder.sh
#../create-secret.sh

echo "1. Build your Docker container"
./a_build-docker.sh

echo "2. Sconify your application"
./b_example-sconify-cmd.sh

echo "3. Register session on the CAS"
./c_create-session.sh

echo "4. Deploy the Helm Chart on the Cluster"
./d_deploy-helm.sh
