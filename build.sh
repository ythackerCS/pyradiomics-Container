cp Dockerfile.base Dockerfile && \
./command2label.py xnat/command.json >> Dockerfile && \
docker build -t xnat/pyradiomicsyt:latest .
docker tag xnat/pyradiomicsyt:latest registry.nrg.wustl.edu/docker/nrg-repo/yash/pyradiomicsyt:latest
rm Dockerfile
