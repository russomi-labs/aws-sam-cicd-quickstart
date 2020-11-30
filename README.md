# aws-sam-cicd-quickstart

## Overview

A quickstart for Serverless Application Model and CI/CD.

## Objectives

- Initialize a new app
- Setup Continuous Integration
- Setup Continuous Deployment

## Prerequisites

- [Installing the AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
- [Setting up AWS credentials](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started-set-up-credentials.html)

## Initialize a new app

### Step 1: Download a sample AWS SAM application

``` bash

$ sam init

Which template source would you like to use?
        1 - AWS Quick Start Templates
        2 - Custom Template Location
Choice: 1

Which runtime would you like to use?
        1 - nodejs12.x
        2 - python3.8
        3 - ruby2.7
        4 - go1.x
        5 - java11
        6 - dotnetcore3.1
        7 - nodejs10.x
        8 - python3.7
        9 - python3.6
        10 - python2.7
        11 - ruby2.5
        12 - java8.al2
        13 - java8
        14 - dotnetcore2.1
Runtime: 2

Project name [sam-app]:

Cloning app templates from https://github.com/awslabs/aws-sam-cli-app-templates.git

AWS quick start application templates:
        1 - Hello World Example
        2 - EventBridge Hello World
        3 - EventBridge App from scratch (100+ Event Schemas)
        4 - Step Functions Sample App (Stock Trader)
        5 - Elastic File System Sample App
Template selection: 1

-----------------------
Generating application:
-----------------------
Name: sam-app
Runtime: python3.8
Dependency Manager: pip
Application Template: hello-world
Output Directory: .

Next steps can be found in the README file at ./sam-app/README.md
```

There are three especially important files:

- template.yaml: Contains the AWS SAM template that defines your application's AWS resources.
- hello_world/app.py: Contains your actual Lambda handler logic.
- hello_world/requirements.txt: Contains any Python dependencies that the application requires, and is used for sam build.

### Step 2: Build your application

``` bash

$ cd sam-app
$ sam build
Building codeuri: hello_world/ runtime: python3.8 metadata: {} functions: ['HelloWorldFunction']
Running PythonPipBuilder:ResolveDependencies
Running PythonPipBuilder:CopySource

Build Succeeded

Built Artifacts  : .aws-sam/build
Built Template   : .aws-sam/build/template.yaml

Commands you can use next
=========================
[*] Invoke Function: sam local invoke
[*] Deploy: sam deploy --guided

```

### Step 3: Deploy your application

``` bash

$ sam deploy --guided

Configuring SAM deploy
======================

        Looking for config file [samconfig.toml] :  Not found

        Setting default arguments for 'sam deploy'
        =========================================
        Stack Name [sam-app]:
        AWS Region [us-east-1]:
        # Shows you resources changes to be deployed and require a 'Y' to initiate deploy
        Confirm changes before deploy [y/N]:
        # SAM needs permission to be able to create roles to connect to the resources in your template
        Allow SAM CLI IAM role creation [Y/n]:
        HelloWorldFunction may not have authorization defined, Is this okay? [y/N]: Y
        Save arguments to configuration file [Y/n]:
        SAM configuration file [samconfig.toml]:
        SAM configuration environment [default]:

        Looking for resources needed for deployment: Not found.
        Creating the required resources...
        Successfully created!

                Managed S3 bucket: aws-sam-cli-managed-default-samclisourcebucket-18oyu9s92geto
                A different default S3 bucket can be set in samconfig.toml

        Saved arguments to config file
        Running 'sam deploy' for future deployments will use the parameters saved above.
        The above parameters can be changed by modifying samconfig.toml
        Learn more about samconfig.toml syntax at
        https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-config.html

        Uploading to sam-app/1696cfa0a6a173b9b948ca162eb56c5a  546199 / 546199.0  (100.00%)

        Deploying with following values
        ===============================
        Stack name                 : sam-app
        Region                     : us-east-1
        Confirm changeset          : False
        Deployment s3 bucket       : aws-sam-cli-managed-default-samclisourcebucket-18oyu9s92geto
        Capabilities               : ["CAPABILITY_IAM"]
        Parameter overrides        : {}
```

## Continuous Integration

### Step 1: Add the nested application

Add the following `AWS::Serverless::Application` to the `template.yaml` :

``` yaml

  awssamcodebuildci:
    Type: AWS::Serverless::Application
    Properties:
      Location:
        ApplicationId: arn:aws:serverlessrepo:us-east-1:646794253159:applications/aws-sam-codebuild-ci
        SemanticVersion: 1.0.0
      Parameters:
        # AWS CodeBuild project compute type.
        # ComputeType: 'BUILD_GENERAL1_SMALL' # Uncomment to override default value
        # Environment type used by AWS CodeBuild. See the documentation for details (https://docs.aws.amazon.com/codebuild/latest/userguide/create-project.html#create-project-cli).
        # EnvironmentType: 'LINUX_CONTAINER' # Uncomment to override default value
        # OAuth token used by AWS CodeBuild to connect to GitHub
        GitHubOAuthToken: YOUR_VALUE
        # GitHub username owning the repo
        GitHubOwner: YOUR_VALUE
        # GitHub repo name
        GitHubRepo: YOUR_VALUE

```

### Step 2: Customize the parameters

- TODO

### Step 3: Deploy

- TODO

### References

- [aws-sam-codebuild-ci](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:646794253159:applications~aws-sam-codebuild-ci)
- [awslabs/aws-sam-codebuild-ci](https://github.com/awslabs/aws-sam-codebuild-ci)

## Continuous Deployment

### Step 1: Add the nested application

Add the following `AWS::Serverless::Application` to the `template.yaml` :

``` bash

  awssamcodepipelinecd:
    Type: AWS::Serverless::Application
    Properties:
      Location:
        ApplicationId: arn:aws:serverlessrepo:us-east-1:646794253159:applications/aws-sam-codepipeline-cd
        SemanticVersion: 1.1.0
      Parameters:
        # Relative BuildSpec file path for build stage. For more information, see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html
        # BuildSpecFilePath: 'buildspec.yaml' # Uncomment to override default value
        # CodeCommit repository branch name, only specify if you chose CodeCommit in SourceCodeProvider.
        # CodeCommitBranch: 'master' # Uncomment to override default value
        # CodeCommit repository name, only specify if you chose CodeCommit in SourceCodeProvider
        # CodeCommitRepo: '' # Uncomment to override default value
        # AWS CodeBuild project compute type.
        # ComputeType: 'BUILD_GENERAL1_SMALL' # Uncomment to override default value
        # Parameter overrides for the deploy stage
        # DeployParameterOverrides: '{}' # Uncomment to override default value
        # The IAM role name to deploy the CloudFormation stack. This role needs to be configured to allow cloudformation.amazonaws.com to assume it. Deploy stage will not be added if not specified.
        # DeployRoleName: '' # Uncomment to override default value
        # The stack name for the deploy stage
        # DeployStackName: '' # Uncomment to override default value
        # Environment type used by AWS CodeBuild. See the documentation for details (https://docs.aws.amazon.com/codebuild/latest/userguide/create-project.html#create-project-cli).
        # EnvironmentType: 'LINUX_CONTAINER' # Uncomment to override default value
        # GitHub repo branch name. It defaults to master if not specified.
        # GitHubBranch: 'master' # Uncomment to override default value
        # OAuth token used by AWS CodePipeline to connect to GitHub
        # GitHubOAuthToken: '' # Uncomment to override default value
        # GitHub username owning the repo
        # GitHubOwner: '' # Uncomment to override default value
        # GitHub repo name
        # GitHubRepo: '' # Uncomment to override default value
        # Relative BuildSpec file path for test stage. For more information, see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html
        # IntegTestBuildSpecFilePath: 'buildspec-integ-test.yaml' # Uncomment to override default value
        # The IAM role name to deploy a test stack and run integration tests. This role needs to be configured to allow codebuild.amazonaws.com and cloudformation.amazonaws.com to assume it. Test stage will not be added if not specified.
        # IntegTestRoleName: '' # Uncomment to override default value
        # Whether to publish the application to AWS Serverless Application Repository
        # PublishToSAR: 'false' # Uncomment to override default value
        # Location of your source code repository
        # SourceCodeProvider: 'GitHub' # Uncomment to override default value

```

### Step 2: Customize the parameters

- TODO

### Step 3: Deploy

- TODO

### References

- [aws-sam-codepipeline-cd](https://console.aws.amazon.com/lambda/home?region=us-east-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:646794253159:applications/aws-sam-codepipeline-cd)
- [aws-sam-codepipeline-cd](https://github.com/awslabs/aws-sam-codepipeline-cd/tree/1.1.0)

## Clean up

- TODO

## Resources

- [Getting started with AWS SAM](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started.html)
- [CICD for Serverless Applications](https://cicd.serverlessworkshops.io/)
- [AWS SAM CLI configuration file](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-config.html)

## What's next

- Learn more ...

## Notes

[Working Backwards](https://www.product-frameworks.com/Amazon-Product-Management.html) - Work backwards from the ideal customer end state.

1. Press Release
2. FAQ
3. User Experience
4. User Manual
