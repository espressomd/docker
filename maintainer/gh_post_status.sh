#!/usr/bin/env bash

[ "$#" -eq 1 ] || exit -1

GIT_COMMIT=$(git rev-parse HEAD)
URL=$(echo "https://gitlab.icp.uni-stuttgart.de/espressomd/docker/pipelines/${CI_PIPELINE_ID}")
STATUS="$1"
curl "https://api.github.com/repos/espressomd/docker/statuses/$GIT_COMMIT?access_token=$GITHUB_TOKEN" \
     -H "Content-Type: application/json" \
     -X POST \
     -d "{\"state\": \"$STATUS\", \"context\": \"ICP GitLab CI\", \"target_url\": \"$URL\"}"
