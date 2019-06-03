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

docker_src=${CI_JOB_NAME%:*}
docker_tag=${CI_JOB_NAME#*:}
test -f "docker/$docker_src/Dockerfile-$docker_tag" || docker_src="ubuntu-python3"
cmd "cd docker/$docker_src"
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel.cfg
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel-15.cfg
test -f Dockerfile-$docker_tag || cmd "sh generate.sh $docker_tag"

if [ "$CI_JOB_STAGE" = "deploy" ]; then
    dest=$CI_JOB_NAME
else
    dest=test/$CI_JOB_NAME-$CI_COMMIT_SHA
fi

cmd "/kaniko/executor --context $PWD --dockerfile Dockerfile-$docker_tag* --destination $CI_REGISTRY/$CI_PROJECT_PATH/$dest"
