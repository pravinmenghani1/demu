#!/bin/bash
# Script to clean up the CI/CD infrastructure

# Set variables
ENVIRONMENT_NAME="CICDDemo"
REGION="us-east-1"  # Change to your preferred region

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

# Function to delete a CloudFormation stack
delete_stack() {
    local stack_name=$1
    
    echo -e "${YELLOW}Deleting stack: ${stack_name}${NC}"
    
    # Check if stack exists
    if aws cloudformation describe-stacks --stack-name ${stack_name} --region ${REGION} 2>&1 | grep -q 'Stack with id'; then
        # Delete stack
        aws cloudformation delete-stack --stack-name ${stack_name} --region ${REGION}
        check_success
        
        echo "Waiting for stack deletion to complete..."
        aws cloudformation wait stack-delete-complete --stack-name ${stack_name} --region ${REGION}
        check_success
    else
        echo -e "${YELLOW}Stack does not exist, skipping...${NC}"
    fi
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

# Empty the S3 bucket
echo -e "${YELLOW}Emptying S3 artifact bucket...${NC}"
BUCKET_NAME="${ENVIRONMENT_NAME}-artifacts-$(aws sts get-caller-identity --query Account --output text)-${REGION}"
aws s3 rm s3://${BUCKET_NAME} --recursive --region ${REGION} || true

# Delete stacks in reverse order
delete_stack "${ENVIRONMENT_NAME}-cicd"
delete_stack "${ENVIRONMENT_NAME}-ec2-asg"
delete_stack "${ENVIRONMENT_NAME}-iam"
delete_stack "${ENVIRONMENT_NAME}-security"
delete_stack "${ENVIRONMENT_NAME}-network"

echo -e "${GREEN}Cleanup complete!${NC}"
