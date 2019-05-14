#!/bin/sh

# execute and output a command
function cmd {
    echo ">$1"
    eval $1
    if [ "$?" != "0" ]; then
        echo "Command failed" >&2
        exit
    fi
}

cmd "cd docker/${CI_JOB_NAME%:*}"
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel.cfg
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel-15.cfg
test -f Dockerfile-${CI_JOB_NAME#*:} || cmd "./generate.sh ${CI_JOB_NAME#*:}"
cmd "docker build -f Dockerfile-${CI_JOB_NAME#*:}* --pull -t $CI_REGISTRY/$CI_PROJECT_PATH/test/$CI_JOB_NAME-$CI_COMMIT_SHA --cache-from $CI_REGISTRY/$CI_PROJECT_PATH/$CI_JOB_NAME ."
cmd "docker push $CI_REGISTRY/$CI_PROJECT_PATH/test/$CI_JOB_NAME-$CI_COMMIT_SHA"
test "$CI_COMMIT_REF_NAME" != "master" || cmd "docker tag $CI_REGISTRY/$CI_PROJECT_PATH/test/$CI_JOB_NAME-$CI_COMMIT_SHA $CI_REGISTRY/$CI_PROJECT_PATH/$CI_JOB_NAME"
test "$CI_COMMIT_REF_NAME" != "master" || cmd "docker push $CI_REGISTRY/$CI_PROJECT_PATH/$CI_JOB_NAME"

