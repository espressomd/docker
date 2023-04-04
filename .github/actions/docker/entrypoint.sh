#!/bin/sh -l

image=$1
repository=$2
username=$(echo "$2" | cut -d'/' -f1 | tr '[:upper:]' '[:lower:]')
project=$(echo "$2" | cut -d'/' -f2)
password=$3
event_name=$4
tag=$5

echo "Log in to registry."
echo "${password}" | docker login -u "${username}" --password-stdin docker.pkg.github.com || exit 1

full_tag="docker.pkg.github.com/${username}/${project}/${image}:${tag}"
dockerfile="docker/Dockerfile-${image}"
full_tag_github_action=""
if grep -q "FROM image_base AS image_standalone" "${dockerfile}"; then
  full_tag_github_action="${full_tag}-base-layer"
fi

echo "Building image with tag: ${full_tag}"
docker build docker -t "${full_tag}" -f "${dockerfile}" || exit 1
if [ ! -z "${full_tag_github_action}" ]; then
  echo "Building GitHub Action-specific image with tag: ${full_tag_github_action}"
  docker build docker -t "${full_tag_github_action}" -f "${dockerfile}" --target image_base || exit 1
fi

if [ "${event_name}" = "pull_request" ]; then
    echo "Pull request: not pushing to registry."
else
    echo "Pushing to registry."
    docker push "${full_tag}" || exit 1
    if [ ! -z "${full_tag_github_action}" ]; then
      docker push "${full_tag_github_action}" || exit 1
    fi
fi
