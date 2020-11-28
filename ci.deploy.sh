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
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"
CFN_BUCKET="$STACK_NAME-cfn-$AWS_ACCOUNT_ID"

echo -e "\n\n=========== Deploying ci.template.yaml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME-ci \
  --template-file ci.template.yaml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
  --parameter-overrides \
    GitHubOwner=$GH_OWNER \
    GitHubRepo=$GH_REPO \
    GitHubOAuthTokenSecretId=$GH_ACCESS_TOKEN_SECRET_ID

# # Package up CloudFormation templates into an S3 bucket
# echo -e "\n\n=========== Packaging main.yml ==========="
# mkdir -p ./cfn_output

# PACKAGE_ERR="$(aws cloudformation package \
#   --region $REGION \
#   --profile $CLI_PROFILE \
#   --template templates/main.yaml \
#   --s3-bucket $CFN_BUCKET \
#   --output-template-file ./cfn_output/main.yaml 2>&1)"

# if ! [[ $PACKAGE_ERR =~ "Successfully packaged artifacts" ]]; then
#   echo "ERROR while running 'aws cloudformation package' command:"
#   echo $PACKAGE_ERR
#   exit 1
# fi

# # Deploy the CloudFormation template
# echo -e "\n\n=========== Deploying main.yml ==========="
# aws cloudformation deploy \
#   --region $REGION \
#   --profile $CLI_PROFILE \
#   --stack-name $STACK_NAME \
#   --template-file ./cfn_output/main.yaml \
#   --no-fail-on-empty-changeset \
#   --capabilities CAPABILITY_NAMED_IAM \
#   --parameter-overrides \
#   GitHubOwner=$GH_OWNER \
#   GitHubRepo=$GH_REPO \
#   GitHubBranch=$GH_BRANCH \
#   GitHubPersonalAccessToken=$GH_ACCESS_TOKEN \
#   CodePipelineBucket=$CODEPIPELINE_BUCKET \
#   Subnets=$SUBNETS \
#   SecurityGroupIds=$SECURITY_GROUP_IDS \
#   RepositoryName=$IMAGE_REPO_NAME

# # If the deploy succeeded, list exports
# if [ $? -eq 0 ]; then
#   echo -e "Deploy Succeeded."
#   # aws cloudformation list-exports \
#   #   --query "Exports[?ends_with(Name,'LBEndpoint')].Value"
# fi