#!/bin/bash
#set -ex

# This will create the pr from branch to the mention branches
pr_message_summary=""
createPR() {
    BRANCH_FROM=$1    
    UPDATED_PR_TITLE="$BRANCH_FROM -> $BRANCH_TO: ${PR_TITLE}"
    echo "Creating PR on Bitbucket Repo: ${GIT_BASE_URL} -> ${GIT_PROJECT} -> ${GIT_REPO} with details: "
    echo "- Title: ${UPDATED_PR_TITLE}"
    echo "- Description: ${PR_DESCRIPTION}"
    echo "- Source Branch: ${BRANCH_FROM}"
    echo "- Target Branch: ${BRANCH_TO}"
    echo "- Reviewers: ${PR_REVIEWERS}"

    IFS=',' read -r -a REVIEWERS <<<"$PR_REVIEWERS"
    REVIEWER_LIST=""
    for name in "${REVIEWERS[@]}"; do
        if ! [[ ${REVIEWER_LIST} == "" ]]; then
            REVIEWER_LIST="${REVIEWER_LIST},"
        fi
        REVIEWER_LIST="${REVIEWER_LIST}{\"user\": {\"name\": \"${name}\"}}"
    done
    echo "- Reviewer PR Input: ${REVIEWER_LIST}"

    echo "Calling bitbucket create PR API..."
    response=$(curl --location --request POST "${GIT_BASE_URL}/rest/api/1.0/projects/${GIT_PROJECT}/repos/${GIT_REPO}/pull-requests" \
        --header "Authorization: Bearer ${GIT_ACCESS_TOKEN}" \
        --header 'Content-Type: application/json' \
        --data-binary "{
    \"title\": \"${UPDATED_PR_TITLE}\",
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
        ${REVIEWER_LIST}
    ]
}")
    echo "------------------------ ------------------------------"
    echo "$response"
    echo "PR creation complete...."

    PATTERN="$GIT_BASE_URL/projects/$GIT_PROJECT/repos/$GIT_REPO/pull-requests/[0-9]*"
    PR_LINK=($(echo "$response" | grep -Eo -1 "$PATTERN"))
    echo "Created PR: $PR_LINK"
    pr_message_summary+="\n*\`${BRANCH_FROM} x ${BRANCH_TO}\`* \n\`\`\`- ${PR_LINK}\`\`\` \n"
}

# Convert into  branches into array
IFS=' ' read -a source_branch_list <<<"${BRANCH_FROM}"
# Parse list of source branches to create PR for them
echo -e "\nsource_branch_list: \n ${source_branch_list[@]}"
for source_branch in "${source_branch_list[@]}"; do
    createPR $source_branch || continue
done

# Expose PR links environment variable
if [ -z "$pr_message_summary" ]; then
    echo "No PRs created"
else
    echo -e "\npr_message_summary: ${pr_message_summary}"
    envman add --key PR_LINK --value "${pr_message_summary}"
fi
