#!/bin/sh -l

image=$1
repository=$2
username=$(echo "$2" | cut -d'/' -f1 | tr '[:upper:]' '[:lower:]')
project=$(echo "$2" | cut -d'/' -f2)
password=$3
event_name=$4
tag=$5

echo "Log in to registry."
echo $password | docker login -u ${username} --password-stdin docker.pkg.github.com

echo "Building image."
docker build docker -t docker.pkg.github.com/${username}/${project}/${image}:${tag} -f docker/Dockerfile-${image}

if [ "$event_name" != "pull_request" ]; then
    echo "Pushing to registry."
    docker push docker.pkg.github.com/${username}/${project}/${image}:${tag}
else
    echo "Pull request: not pushing to registry."
fi
