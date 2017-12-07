#!/usr/bin/env bash

set -e
root_dir=$(git rev-parse --show-toplevel)
cd $root_dir/docker
for i in $(find -maxdepth 1 -mindepth 1 -type d -printf '%f\n');
do
    cd $i
    docker build -t test_${i} . 
    docker build --build-arg image=test_${i} ${root_dir}/test
    cd ..
done
