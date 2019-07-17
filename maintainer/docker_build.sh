#!/bin/sh

# execute and output a command
function cmd {
    echo ">$1"
    eval $1
    ret=$?
    if [ "$ret" != "0" ]; then
        echo "Command failed" >&2
        exit $ret
    fi
}

job_name=${CI_JOB_NAME%:build}
docker_src=${job_name%:*}
docker_tag=${job_name#*:}
cmd "cd docker/$docker_src"
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel-15.cfg

if [ "$CI_JOB_STAGE" = "deploy" ]; then
    dest=$job_name
else
    dest=test/$job_name-$CI_COMMIT_SHA
fi

cmd "/kaniko/executor --context $PWD --dockerfile Dockerfile-$docker_tag* --destination $CI_REGISTRY/$CI_PROJECT_PATH/$dest"
