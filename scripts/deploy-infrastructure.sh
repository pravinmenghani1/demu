#!/bin/bash
# Script to deploy the complete CI/CD infrastructure

# Set variables
ENVIRONMENT_NAME="CICDDemo"
REGION="us-east-1"  # Change to your preferred region
GITHUB_OWNER=""     # Your GitHub username
GITHUB_REPO=""      # Your GitHub repository name
GITHUB_BRANCH="main"
GITHUB_TOKEN=""     # Your GitHub OAuth token

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if command was successful
check_success() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Success${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
        exit 1
    fi
}

# Function to deploy a CloudFormation stack
deploy_stack() {
    local stack_name=$1
    local template_file=$2
    local parameters=$3
    
    echo -e "${YELLOW}Deploying stack: ${stack_name}${NC}"
    
    # Check if stack exists
    if aws cloudformation describe-stacks --stack-name ${stack_name} --region ${REGION} &>/dev/null; then
        # Update stack
        echo "Stack exists, updating..."
        aws cloudformation update-stack \
            --stack-name ${stack_name} \
            --template-body file://${template_file} \
            --parameters ${parameters} \
            --capabilities CAPABILITY_NAMED_IAM \
            --region ${REGION}
    else
        # Create stack
        echo "Stack does not exist, creating..."
        aws cloudformation create-stack \
            --stack-name ${stack_name} \
            --template-body file://${template_file} \
            --parameters ${parameters} \
            --capabilities CAPABILITY_NAMED_IAM \
            --region ${REGION}
    fi
    
    check_success
    
    echo "Waiting for stack to complete..."
    aws cloudformation wait stack-create-complete --stack-name ${stack_name} --region ${REGION} 2>/dev/null || \
    aws cloudformation wait stack-update-complete --stack-name ${stack_name} --region ${REGION}
    check_success
}

# Check AWS CLI is installed
echo -e "${YELLOW}Checking AWS CLI installation...${NC}"
if ! command -v aws &> /dev/null; then
    echo -e "${RED}AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ AWS CLI is installed${NC}"

# Check AWS credentials
echo -e "${YELLOW}Checking AWS credentials...${NC}"
aws sts get-caller-identity > /dev/null
check_success

# Prompt for GitHub information if not provided
if [ -z "$GITHUB_OWNER" ]; then
    read -p "Enter your GitHub username: " GITHUB_OWNER
fi

if [ -z "$GITHUB_REPO" ]; then
    read -p "Enter your GitHub repository name: " GITHUB_REPO
fi

if [ -z "$GITHUB_TOKEN" ]; then
    read -p "Enter your GitHub OAuth token: " GITHUB_TOKEN
fi

# Deploy Network Stack
deploy_stack "${ENVIRONMENT_NAME}-network" "../infrastructure/01-network.yml" \
    "ParameterKey=EnvironmentName,ParameterValue=${ENVIRONMENT_NAME}"

# Deploy Security Stack
deploy_stack "${ENVIRONMENT_NAME}-security" "../infrastructure/02-security.yml" \
    "ParameterKey=EnvironmentName,ParameterValue=${ENVIRONMENT_NAME}"

# Deploy IAM Stack
deploy_stack "${ENVIRONMENT_NAME}-iam" "../infrastructure/03-iam.yml" \
    "ParameterKey=EnvironmentName,ParameterValue=${ENVIRONMENT_NAME}"

# Deploy EC2 and ASG Stack
deploy_stack "${ENVIRONMENT_NAME}-ec2-asg" "../infrastructure/04-ec2-asg.yml" \
    "ParameterKey=EnvironmentName,ParameterValue=${ENVIRONMENT_NAME} ParameterKey=InstanceType,ParameterValue=t3.micro"

# Deploy CI/CD Pipeline Stack
deploy_stack "${ENVIRONMENT_NAME}-cicd" "../infrastructure/05-cicd-pipeline.yml" \
    "ParameterKey=EnvironmentName,ParameterValue=${ENVIRONMENT_NAME} \
     ParameterKey=GitHubOwner,ParameterValue=${GITHUB_OWNER} \
     ParameterKey=GitHubRepo,ParameterValue=${GITHUB_REPO} \
     ParameterKey=GitHubBranch,ParameterValue=${GITHUB_BRANCH} \
     ParameterKey=GitHubToken,ParameterValue=${GITHUB_TOKEN}"

# Get the load balancer URL
echo -e "${YELLOW}Getting application URL...${NC}"
LB_URL=$(aws cloudformation describe-stacks \
    --stack-name ${ENVIRONMENT_NAME}-ec2-asg \
    --query "Stacks[0].Outputs[?OutputKey=='LoadBalancerDNS'].OutputValue" \
    --output text \
    --region ${REGION})

echo -e "${GREEN}Deployment complete!${NC}"
echo -e "${YELLOW}Application URL:${NC} http://${LB_URL}"
echo -e "${YELLOW}CodePipeline URL:${NC} https://${REGION}.console.aws.amazon.com/codesuite/codepipeline/pipelines/${ENVIRONMENT_NAME}-pipeline/view?region=${REGION}"
