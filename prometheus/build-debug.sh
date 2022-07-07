docker build -f Dockerfile_debug . -t 5gzorro-prometheus-debug
#docker stop  --name "prometheus-debug"
#docker run -it -d 5gzorro-prometheus-debug --name "prometheus-debug"
docker run -it 5gzorro-prometheus-debug
