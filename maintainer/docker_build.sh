#!/bin/sh

abort()
{
    echo "An error occurred. Exiting..." >&2
    echo "Command that failed: $BASH_COMMAND" >&2
    exit 1
}

trap 'abort' 0
set -ex

cd docker/${CI_JOB_NAME%:*}
echo "ACTIVATION_LICENSE_FILE=$INTEL_LICENSE_SERVER" >> intel.cfg
test -f Dockerfile-${CI_JOB_NAME#*:} || ./generate.sh ${CI_JOB_NAME#*:}
docker build -f Dockerfile-${CI_JOB_NAME#*:}* --pull -t $CI_REGISTRY/$CI_PROJECT_PATH/test/$CI_JOB_NAME-$CI_COMMIT_SHA --cache-from $CI_REGISTRY/$CI_PROJECT_PATH/$CI_JOB_NAME .
docker push $CI_REGISTRY/$CI_PROJECT_PATH/test/$CI_JOB_NAME-$CI_COMMIT_SHA
test "$CI_COMMIT_REF_NAME" != "master" || docker tag $CI_REGISTRY/$CI_PROJECT_PATH/test/$CI_JOB_NAME-$CI_COMMIT_SHA $CI_REGISTRY/$CI_PROJECT_PATH/$CI_JOB_NAME
test "$CI_COMMIT_REF_NAME" != "master" || docker push $CI_REGISTRY/$CI_PROJECT_PATH/$CI_JOB_NAME

trap : 0
