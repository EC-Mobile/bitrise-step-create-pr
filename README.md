# PR-Create

You can use this step to create PR on your bitbucket repo. 

This step uses BitBucket V1 api.


## Required Params and Sample Values

You need to pass these param, all are required:

### Secure Params:

- GIT_ACCESS_TOKEN:                                 You can create in your bitbucket account settings.

### Normal Params;
- GIT_BASE_URL:                                     https://git.mydomain.com
- GIT_PROJECT:                                      My-MOBILE
- GIT_REPO:                                         app-ios
- PR_TITLE:                                         This is a Test PR
- PR_DESCRIPTION:                                   Created from bash script...
- BRANCH_TO:                                        develop
- BRANCH_FROM:                                      master
- PR_REVIEWERS:                                     kage.ryu,ken.ryu

### Output Params;
- PR_LINK:                                          https://git.mydomain.com/.../pullrequest/123

## How to use this Step

Add this in your bitrise.yml file and replace proper variables:
```
- git::https://github.com/EC-Mobile/bitrise-step-create-pr.git@main:
        title: PR Creator
        inputs:
        - GIT_BASE_URL: https://git.mydomain.com
        - GIT_ACCESS_TOKEN: <Variable>
        - GIT_PROJECT: <Project>
        - GIT_REPO: <Repo>
        - PR_TITLE: "[Merge Me With Care] - From $BITRISE_GIT_BRANCH -> Develop"
        - PR_DESCRIPTION: This PR is created from CI !!\\n*Only merge when you see
            code will not disturbe the develop branch.
        - BRANCH_TO: develop
        - BRANCH_FROM: <Variable>
        - PR_REVIEWERS: <Variable>
```
