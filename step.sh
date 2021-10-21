#!/bin/bash
set -ex

# This will create the pr from branch to the mention branches

echo "Creating PR on Bitbucket Repo: ${GIT_BASE_URL} -> ${GIT_PROJECT} -> ${GIT_REPO} with details: "
echo "- Title: ${PR_TITLE}"
echo "- Description: ${PR_DESCRIPTION}"
echo "- Source Branch: ${BRANCH_FROM}"
echo "- Target Branch: ${BRANCH_TO}"
echo "- Reviewer: ${TEAM_LEAD_GIT_NAME}"

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