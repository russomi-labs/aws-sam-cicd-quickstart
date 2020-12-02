#!/bin/bash

STACK_NAME="aws-sam-cicd-quickstart"
REGION="us-east-1"
CLI_PROFILE="dev15-sandbox"

# Generate a personal access token with repo and admin:repo_hook
#    permissions from https://github.com/settings/tokens
GH_ACCESS_TOKEN=$(cat ~/.github/aws-sam-cicd-quickstart/GitHubOAuthToken)
GH_ACCESS_TOKEN_SECRET_ID='GitHubOAuthToken2'
GH_OWNER=russomi-labs
GH_REPO=aws-sam-cicd-quickstart
GH_BRANCH=master

# Dynamic parameters
AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
    --query "Account" --output text --profile $CLI_PROFILE)
# CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"
# CFN_BUCKET="$STACK_NAME-cfn-$AWS_ACCOUNT_ID"

# Check for config else use --guided

echo -e "\n\n=========== Deploying template.yaml ==========="
sam deploy --parameter-overrides \
    GitHubOwner=$GH_OWNER \
    GitHubRepo=$GH_REPO \
    GitHubOAuthTokenSecretId=$GH_ACCESS_TOKEN_SECRET_ID

# If the deploy succeeded, list exports
if [ $? -eq 0 ]; then
    echo -e "Deploy Succeeded."
    # aws cloudformation list-exports \
    #   --query "Exports[?ends_with(Name,'LBEndpoint')].Value"
fi
