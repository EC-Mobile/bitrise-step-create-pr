#!/bin/bash
set -ex

# This will create the pr from branch to the mention branches

echo "Calling bitbucket create PR API..."
response=$(curl --location --request POST "${GIT_BASE_URL}/rest/api/1.0/projects/${GIT_PROJECT}/repos/${GIT_REPO}/pull-requests" \
--header "Authorization: Bearer ${GIT_ACCESS_TOKEN}" \
--header 'Content-Type: application/json' \
--data-raw "{
    \"title\": \"${PR_TITLE}\",
    \"description\": \"${PR_DESCRIPTION}\",
    \"state\": \"OPEN\",
    \"open\": true,
    \"closed\": false,
    \"fromRef\": {
        \"id\": \"${BRANCH_FROM}\",
        \"repository\": {
            \"slug\": \"${GIT_REPO}\",
            \"name\": null,
            \"project\": {
                \"key\": \"${GIT_PROJECT}\"
            }
        }
    },
    \"toRef\": {
        \"id\": \"${BRANCH_TO}\",
        \"repository\": {
            \"slug\": \"${GIT_REPO}\",
            \"name\": null,
            \"project\": {
                \"key\": \"${GIT_PROJECT}\"
            }
        }
    },
    \"locked\": false,
    \"reviewers\": [
        {
            \"user\": {
                \"name\": \"${TEAM_LEAD_GIT_NAME}\"
            }
        }
    ]
}")
echo $response
echo "PR creation complete...."
envman add --key PR_CREATE_RESPONSE --value $response