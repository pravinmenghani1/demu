# Complete CI/CD Pipeline on AWS

This project demonstrates a complete CI/CD pipeline using AWS services including CodePipeline, CodeBuild, and CodeDeploy with an auto-scaling infrastructure.

## Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub        │    │   CodeBuild      │    │  CodeDeploy     │
│   Repository    │───▶│   Build &        │───▶│  Deployment     │
│                 │    │   Test           │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                         │
                                                         ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   CloudWatch    │    │  Load Balancer   │    │  Auto Scaling   │
│   Monitoring    │◀───│  Traffic         │◀───│  EC2 Instances  │
│                 │    │  Distribution    │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Prerequisites

1. AWS Account with administrative permissions
2. AWS CLI installed and configured
3. GitHub account and repository
4. GitHub OAuth token with repo permissions

## Project Structure

```
manual/
├── app/                      # Application files
│   ├── css/                  # CSS stylesheets
│   ├── js/                   # JavaScript files
│   ├── scripts/              # Deployment scripts
│   ├── appspec.yml           # CodeDeploy configuration
│   ├── buildspec.yml         # CodeBuild configuration
│   └── index.html            # Main HTML file
├── infrastructure/           # CloudFormation templates
│   ├── 01-network.yml        # VPC and networking
│   ├── 02-security.yml       # Security groups
│   ├── 03-iam.yml            # IAM roles
│   ├── 04-ec2-asg.yml        # EC2 and Auto Scaling
│   └── 05-cicd-pipeline.yml  # CI/CD pipeline
└── scripts/                  # Deployment scripts
    ├── deploy-infrastructure.sh  # Deploy CloudFormation stacks
    └── cleanup-infrastructure.sh # Clean up resources
```

## Step-by-Step Deployment Guide

### 1. Prepare Your GitHub Repository

1. Create a new GitHub repository or use an existing one
2. Generate a GitHub OAuth token:
   - Go to GitHub Settings > Developer settings > Personal access tokens
   - Generate a new token with `repo` permissions
   - Save the token securely for later use

### 2. Clone This Repository

```bash
git clone https://github.com/pravinmenghani1/ci-cd-demo.git
cd ci-cd-demo
```

### 3. Push the Application Code to Your Repository

```bash
# Copy the application files to your repository
cp -r /path/to/manual/app/* .

# Commit and push to GitHub
git add .
git commit -m "Initial application code"
git push origin main
```

### 4. Deploy the Infrastructure

```bash
cd scripts
chmod +x deploy-infrastructure.sh
./deploy-infrastructure.sh
```

During the deployment, you will be prompted for:
- Your GitHub username
- Your GitHub repository name
- Your GitHub OAuth token

### 5. Monitor the Deployment

1. Open the AWS Management Console
2. Navigate to CloudFormation to monitor stack creation
3. Once complete, navigate to CodePipeline to see your pipeline in action

### 6. Access Your Application

After the pipeline completes successfully, access your application using the Load Balancer URL provided at the end of the deployment script.

## CI/CD Pipeline Workflow

1. **Source Stage**: CodePipeline pulls the latest code from your GitHub repository when changes are pushed.
2. **Build Stage**: CodeBuild validates HTML files, packages the application, and creates a deployment artifact.
3. **Deploy Stage**: CodeDeploy deploys the application to the EC2 instances in the Auto Scaling Group.

## Infrastructure Components

- **VPC**: Isolated network with public subnets across two availability zones
- **Security Groups**: Control traffic to and from your instances
- **IAM Roles**: Provide necessary permissions for AWS services
- **Auto Scaling Group**: Maintains desired capacity and handles instance failures
- **Application Load Balancer**: Distributes traffic across instances
- **CodePipeline**: Orchestrates the CI/CD workflow
- **CodeBuild**: Builds and tests the application
- **CodeDeploy**: Deploys the application to EC2 instances

## Cleanup

To avoid ongoing charges, clean up the resources when you're done:

```bash
cd scripts
chmod +x cleanup-infrastructure.sh
./cleanup-infrastructure.sh
```

## Customization

- Modify the CloudFormation templates in the `infrastructure/` directory to adjust the infrastructure
- Update the application files in the `app/` directory to change the application
- Edit the deployment scripts in the `scripts/` directory to customize the deployment process

## Troubleshooting

- **Pipeline Failures**: Check the CodePipeline console for error details
- **Deployment Issues**: Check the CodeDeploy logs on the EC2 instances
- **Instance Problems**: Use AWS Systems Manager Session Manager to connect to instances and check logs

## Security Considerations

- The IAM roles follow the principle of least privilege
- Security groups restrict traffic to only necessary ports
- All S3 buckets are encrypted with SSE-S3
- HTTPS should be configured for production use (not included in this demo)

## Cost Considerations

This infrastructure uses the following billable AWS resources:
- EC2 instances (t3.micro)
- Application Load Balancer
- S3 bucket for artifacts
- CloudWatch logs
- CodePipeline, CodeBuild, and CodeDeploy

Estimated monthly cost: $30-50 USD (varies by region and usage)

---

Created by Pravin Menghani with love for DevOps Automated Pipelines. Feel free to reach out at https://cloudcognoscente.com/contact for mentorship or any guidance.
