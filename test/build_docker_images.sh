#!/usr/bin/env bash

# Argument to script is name of the dir that contains the Dockerfile.

dockerfile_dir=$1
root_dir=$(git rev-parse --show-toplevel)
cd $root_dir/docker/${dockerfile_dir}
docker build -q -t test_${dockerfile_dir} .
docker build --build-arg image=test_${dockerfile_dir} ${root_dir}/test
