#!/bin/sh

set -e

# get a list of docker repos, select only those whose name contains "test/", extract their IDs, and convert the resulting list to a plain-text table
for repo_id in $(curl -Ls --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" https://$CI_SERVER_HOST/api/v4/projects/$CI_PROJECT_ID/registry/repositories | jq -r '.[] | select(.name | contains("test/")) | [.id] | @tsv'); do
    # delete all tags older than 7 days
    curl -Ls --request DELETE --data 'name_regex=.+' --data 'older_than=7d' --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" "https://$CI_SERVER_HOST/api/v4/projects/$CI_PROJECT_ID/registry/repositories/$repo_id/tags" | jq
done

