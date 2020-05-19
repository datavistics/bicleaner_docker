# https://medium.com/better-programming/how-to-version-your-docker-images-1d5c577ebf54
set -ex
# docker hub username
USERNAME=datavistics
# image name
IMAGE=bicleaner_docker
docker build -t $USERNAME/$IMAGE:latest .