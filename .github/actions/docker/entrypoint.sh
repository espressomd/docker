#!/bin/sh -l

image=$1
repository=$2
username=$(echo "$2" | cut -d'/' -f1 | tr '[:upper:]' '[:lower:]')
project=$(echo "$2" | cut -d'/' -f2)
password=$3
event_name=$4
tag=$5
dockerhub_user=$6
dockerhub_password=$7

echo "Log in to registry."
echo "${password}" | docker login -u "${username}" --password-stdin docker.pkg.github.com || exit 1

full_tag="docker.pkg.github.com/${username}/${project}/${image}:${tag}"

echo "Building image with tag: ${full_tag}"
docker build docker -t "${full_tag}" -f "docker/Dockerfile-${image}" || exit 1

if [ "${event_name}" != "pull_request" ]; then
    echo "Pushing to registry."
    docker push "${full_tag}" || exit 1
    if [ "${dockerhub_user}" != "" ]; then
        echo "${dockerhub_password}" | docker login -u "${dockerhub_user}" --password-stdin || exit 1
        docker tag "${full_tag} ${username}/${project}-${image}:${tag}"
        docker push "${username}/${project}-${image}:${tag}" || exit 1
    fi  
else
    echo "Pull request: not pushing to registry."
fi
