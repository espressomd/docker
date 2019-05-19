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

cmd "cd docker/${CI_JOB_NAME%:*}"
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel.cfg
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel-15.cfg
test -f Dockerfile-${CI_JOB_NAME#*:} || cmd "./generate.sh ${CI_JOB_NAME#*:}"
cmd "/kaniko/executor --context $PWD --dockerfile Dockerfile-${CI_JOB_NAME#*:}* --destination $CI_REGISTRY/$CI_PROJECT_PATH/test/$CI_JOB_NAME-$CI_COMMIT_SHA --cache=true --cache-repo $CI_REGISTRY/$CI_PROJECT_PATH/cache"
test "$CI_COMMIT_REF_NAME" != "master" || cmd "/kaniko/executor --context $PWD --dockerfile Dockerfile-${CI_JOB_NAME#*:}* --destination $CI_REGISTRY/$CI_PROJECT_PATH/$CI_JOB_NAME --cache=true --cache-repo $CI_REGISTRY/$CI_PROJECT_PATH/cache"
