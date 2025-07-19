# Complete CI/CD Pipeline: Detailed Step-by-Step Guide

This guide provides detailed instructions for setting up a complete CI/CD pipeline on AWS, covering every step from initial setup to final deployment.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setting Up Your GitHub Repository](#setting-up-your-github-repository)
3. [Creating AWS Infrastructure](#creating-aws-infrastructure)
4. [Setting Up the CI/CD Pipeline](#setting-up-the-ci/cd-pipeline)
5. [Testing the Pipeline](#testing-the-pipeline)
6. [Monitoring and Maintenance](#monitoring-and-maintenance)
7. [Troubleshooting](#troubleshooting)
8. [Cleanup](#cleanup)

## Prerequisites

### 1. AWS Account Setup

1. **Create an AWS Account** (if you don't have one):
   - Go to [AWS Console](https://aws.amazon.com/)
   - Click "Create an AWS Account"
   - Follow the registration process

2. **Set up IAM User**:
   - Sign in to the AWS Management Console
   - Navigate to IAM service
   - Create a new user with programmatic access
   - Attach the `AdministratorAccess` policy
   - Save the Access Key ID and Secret Access Key

3. **Install AWS CLI**:
   - Download from [AWS CLI website](https://aws.amazon.com/cli/)
   - Install following the instructions for your operating system
   - Configure with your credentials:
     ```bash
     aws configure
     ```
   - Enter your Access Key ID, Secret Access Key, default region (e.g., us-east-1), and output format (json)

### 2. GitHub Setup

1. **Create a GitHub Repository**:
   - Go to [GitHub](https://github.com/)
   - Click "New repository"
   - Name it (e.g., "ci-cd-demo")
   - Choose public or private
   - Initialize with a README
   - Click "Create repository"

2. **Generate GitHub OAuth Token**:
   - Go to GitHub Settings > Developer settings > Personal access tokens
   - Click "Generate new token"
   - Give it a name (e.g., "AWS CI/CD Pipeline")
   - Select scopes: `repo` (full control of repositories)
   - Click "Generate token"
   - **IMPORTANT**: Copy and save the token securely; you won't see it again

## Setting Up Your GitHub Repository

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/ci-cd-demo.git
cd ci-cd-demo
```

### 2. Add Application Files

1. **Copy the application files**:
   ```bash
   cp -r /path/to/manual/app/* .
   ```

2. **Commit and push**:
   ```bash
   git add .
   git commit -m "Add application files"
   git push origin main
   ```

## Creating AWS Infrastructure

### 1. Network Infrastructure

1. **Create VPC and Subnets**:
   - Sign in to AWS Management Console
   - Navigate to CloudFormation
   - Click "Create stack" > "With new resources"
   - Upload the `01-network.yml` template
   - Name the stack "CICDDemo-network"
   - Enter parameters (or use defaults)
   - Click "Next" through the options
   - Review and click "Create stack"
   - Wait for the stack to complete (Status: CREATE_COMPLETE)

### 2. Security Groups

1. **Create Security Groups**:
   - In CloudFormation, click "Create stack"
   - Upload the `02-security.yml` template
   - Name the stack "CICDDemo-security"
   - Enter parameters (use the same environment name as before)
   - Complete the stack creation process
   - Wait for completion

### 3. IAM Roles

1. **Create IAM Roles**:
   - In CloudFormation, click "Create stack"
   - Upload the `03-iam.yml` template
   - Name the stack "CICDDemo-iam"
   - Enter parameters
   - Complete the stack creation process
   - Wait for completion

### 4. EC2 and Auto Scaling Group

1. **Create EC2 Infrastructure**:
   - In CloudFormation, click "Create stack"
   - Upload the `04-ec2-asg.yml` template
   - Name the stack "CICDDemo-ec2-asg"
   - Enter parameters (instance type, key pair if needed)
   - Complete the stack creation process
   - Wait for completion (this may take 5-10 minutes)

### 5. Automated Deployment

Instead of manually creating each stack, you can use the provided script:

```bash
cd scripts
chmod +x deploy-infrastructure.sh
./deploy-infrastructure.sh
```

This script will:
- Deploy all CloudFormation stacks in the correct order
- Prompt for your GitHub information
- Wait for each stack to complete before proceeding
- Output the application URL when finished

## Setting Up the CI/CD Pipeline

### 1. Create CI/CD Pipeline

1. **Deploy the Pipeline Stack**:
   - In CloudFormation, click "Create stack"
   - Upload the `05-cicd-pipeline.yml` template
   - Name the stack "CICDDemo-cicd"
   - Enter parameters:
     - Environment name: CICDDemo
     - GitHub owner: your GitHub username
     - GitHub repo: your repository name
     - GitHub branch: main
     - GitHub token: your OAuth token
   - Complete the stack creation process
   - Wait for completion

### 2. Verify Pipeline Creation

1. **Check CodePipeline**:
   - Navigate to AWS CodePipeline in the console
   - You should see a pipeline named "CICDDemo-pipeline"
   - The pipeline should start automatically after creation

### 3. Initial Pipeline Execution

1. **Monitor the Pipeline**:
   - The pipeline will go through three stages:
     - Source: Pull code from GitHub
     - Build: Build and package the application
     - Deploy: Deploy to EC2 instances
   - Each stage should show "Succeeded" when complete
   - If any stage fails, click on "Details" to see the error

## Testing the Pipeline

### 1. Access the Application

1. **Get the Load Balancer URL**:
   - In CloudFormation, go to the "CICDDemo-ec2-asg" stack
   - Go to the "Outputs" tab
   - Find the "LoadBalancerDNS" value
   - Open this URL in a web browser

2. **Verify the Application**:
   - You should see the CI/CD Demo application
   - The status should show "Online"
   - Server information should be displayed

### 2. Test the CI/CD Process

1. **Make a Change to the Application**:
   - Edit the `index.html` file in your local repository
   - Change the version number or add a new feature
   - Commit and push the changes:
     ```bash
     git add index.html
     git commit -m "Update application version"
     git push origin main
     ```

2. **Monitor the Pipeline**:
   - Go to CodePipeline in the AWS Console
   - The pipeline should start automatically
   - Watch it progress through the stages

3. **Verify the Deployment**:
   - After the pipeline completes, refresh the application URL
   - You should see your changes reflected

## Monitoring and Maintenance

### 1. Set Up CloudWatch Alarms

1. **Create CPU Utilization Alarm**:
   - Navigate to CloudWatch in the AWS Console
   - Click "Alarms" > "Create alarm"
   - Select "EC2 > Per-Instance Metrics"
   - Find your instances and select "CPUUtilization"
   - Set threshold (e.g., greater than 80% for 5 minutes)
   - Configure notification (optional)
   - Name and create the alarm

### 2. View Logs

1. **CodeBuild Logs**:
   - Go to CodeBuild in the AWS Console
   - Select your build project
   - Click on a build run
   - View the build logs

2. **EC2 Instance Logs**:
   - Connect to an instance using AWS Systems Manager Session Manager
   - View Apache logs: `sudo cat /var/log/apache2/error.log`
   - View deployment logs: `sudo cat /var/log/aws/codedeploy-agent/codedeploy-agent.log`

### 3. Monitor Auto Scaling

1. **View Auto Scaling Activity**:
   - Go to EC2 > Auto Scaling Groups
   - Select your ASG
   - Go to the "Activity" tab
   - View scaling activities and health status

## Troubleshooting

### 1. Pipeline Failures

1. **Source Stage Failures**:
   - Check GitHub repository permissions
   - Verify the OAuth token is valid
   - Ensure the repository exists and contains the required files

2. **Build Stage Failures**:
   - Check the buildspec.yml file for errors
   - View the CodeBuild logs for detailed error messages
   - Verify that all required files exist in the repository

3. **Deploy Stage Failures**:
   - Check the appspec.yml file for errors
   - Verify that the deployment group is correctly configured
   - Check instance health in the Auto Scaling Group
   - View CodeDeploy logs on the instances

### 2. Application Issues

1. **Application Not Accessible**:
   - Check if the Load Balancer is healthy
   - Verify that the target group has healthy instances
   - Check security group rules to ensure port 80 is open
   - Connect to instances and check if Apache is running

2. **Application Errors**:
   - Check Apache error logs
   - Verify file permissions in /var/www/html/
   - Check deployment scripts for errors

## Cleanup

### 1. Manual Cleanup

1. **Delete CloudFormation Stacks** (in reverse order):
   - CICDDemo-cicd
   - CICDDemo-ec2-asg
   - CICDDemo-iam
   - CICDDemo-security
   - CICDDemo-network

2. **Empty S3 Bucket**:
   - Navigate to S3 in the AWS Console
   - Find the artifacts bucket
   - Empty the bucket before deleting the stack

### 2. Automated Cleanup

```bash
cd scripts
chmod +x cleanup-infrastructure.sh
./cleanup-infrastructure.sh
```

This script will:
- Empty the S3 artifact bucket
- Delete all CloudFormation stacks in the correct order
- Wait for each deletion to complete before proceeding

## Conclusion

Congratulations! You have successfully set up a complete CI/CD pipeline on AWS. This pipeline automatically builds, tests, and deploys your application whenever you push changes to your GitHub repository. The infrastructure is highly available across multiple availability zones and can scale based on demand.

For more advanced configurations, consider:
- Adding unit and integration tests to the build stage
- Implementing blue/green deployments
- Setting up a custom domain with HTTPS
- Adding more sophisticated monitoring and alerting

---

Created by Pravin Menghani with love for DevOps Automated Pipelines. Feel free to reach out at https://cloudcognoscente.com/contact for mentorship or any guidance.
