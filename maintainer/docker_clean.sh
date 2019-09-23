#!/bin/sh

set -e

for repo_id in $(curl -Ls --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" https://$CI_SERVER_HOST/api/v4/projects/$CI_PROJECT_ID/registry/repositories | jq -r '.[] | select(.name | contains("test/")) | [.id] | @tsv'); do
    curl -Ls --request DELETE --data 'name_regex=.+' --data 'older_than=7d' --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" "https://$CI_SERVER_HOST/api/v4/projects/$CI_PROJECT_ID/registry/repositories/$repo_id/tags" | jq
done

