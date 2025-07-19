# CI/CD Pipeline Project File Summary

This document provides an overview of all files in the project and their purposes.

## Application Files

| File/Directory | Purpose |
|---------------|---------|
| `app/index.html` | Main HTML file for the web application |
| `app/css/styles.css` | CSS stylesheet for the web application |
| `app/js/app.js` | JavaScript code for the web application |
| `app/appspec.yml` | Configuration file for AWS CodeDeploy |
| `app/buildspec.yml` | Configuration file for AWS CodeBuild |
| `app/scripts/before_install.sh` | Script that runs before deployment |
| `app/scripts/after_install.sh` | Script that runs after deployment |
| `app/scripts/start_application.sh` | Script that starts the application |
| `app/scripts/validate_service.sh` | Script that validates the deployment |

## Infrastructure Files

| File | Purpose |
|------|---------|
| `infrastructure/01-network.yml` | CloudFormation template for VPC and networking |
| `infrastructure/02-security.yml` | CloudFormation template for security groups |
| `infrastructure/03-iam.yml` | CloudFormation template for IAM roles |
| `infrastructure/04-ec2-asg.yml` | CloudFormation template for EC2 and Auto Scaling |
| `infrastructure/05-cicd-pipeline.yml` | CloudFormation template for CI/CD pipeline |

## Deployment Scripts

| File | Purpose |
|------|---------|
| `scripts/deploy-infrastructure.sh` | Script to deploy all CloudFormation stacks |
| `scripts/cleanup-infrastructure.sh` | Script to delete all AWS resources |

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Main project documentation with overview and instructions |
| `STEP_BY_STEP_GUIDE.md` | Detailed step-by-step guide for setting up the pipeline |
| `PIPELINE_DIAGRAM.txt` | Text-based diagram of the CI/CD pipeline architecture |
| `COST_ESTIMATION.md` | Estimated costs for running the infrastructure |
| `TROUBLESHOOTING.md` | Guide for resolving common issues |
| `VERIFICATION_CHECKLIST.md` | Checklist for verifying the pipeline setup |
| `FILE_SUMMARY.md` | This file - summary of all project files |

## File Structure

```
manual/
├── app/                      # Application files
│   ├── css/
│   │   └── styles.css
│   ├── js/
│   │   └── app.js
│   ├── scripts/
│   │   ├── before_install.sh
│   │   ├── after_install.sh
│   │   ├── start_application.sh
│   │   └── validate_service.sh
│   ├── appspec.yml
│   ├── buildspec.yml
│   └── index.html
├── infrastructure/           # CloudFormation templates
│   ├── 01-network.yml
│   ├── 02-security.yml
│   ├── 03-iam.yml
│   ├── 04-ec2-asg.yml
│   └── 05-cicd-pipeline.yml
├── scripts/                  # Deployment scripts
│   ├── deploy-infrastructure.sh
│   └── cleanup-infrastructure.sh
└── documentation/            # Documentation files
    ├── README.md
    ├── STEP_BY_STEP_GUIDE.md
    ├── PIPELINE_DIAGRAM.txt
    ├── COST_ESTIMATION.md
    ├── TROUBLESHOOTING.md
    ├── VERIFICATION_CHECKLIST.md
    └── FILE_SUMMARY.md
```

## Key File Relationships

1. **Infrastructure Deployment Flow**:
   - `scripts/deploy-infrastructure.sh` deploys the CloudFormation templates in order:
     1. `infrastructure/01-network.yml`
     2. `infrastructure/02-security.yml`
     3. `infrastructure/03-iam.yml`
     4. `infrastructure/04-ec2-asg.yml`
     5. `infrastructure/05-cicd-pipeline.yml`

2. **CI/CD Pipeline Flow**:
   - When code is pushed to GitHub, the pipeline is triggered
   - CodeBuild uses `app/buildspec.yml` to build the application
   - CodeDeploy uses `app/appspec.yml` to deploy the application
   - Deployment scripts in `app/scripts/` are executed during deployment

3. **Application Deployment Flow**:
   - `app/scripts/before_install.sh` prepares the instance
   - `app/scripts/after_install.sh` configures the application
   - `app/scripts/start_application.sh` starts the application
   - `app/scripts/validate_service.sh` validates the deployment

## Customization Points

1. **Application Customization**:
   - Modify `app/index.html`, `app/css/styles.css`, and `app/js/app.js` to change the application

2. **Infrastructure Customization**:
   - Modify CloudFormation templates in `infrastructure/` to change the infrastructure
   - Update parameters in `scripts/deploy-infrastructure.sh` to change deployment settings

3. **Deployment Customization**:
   - Modify `app/buildspec.yml` to change the build process
   - Modify `app/appspec.yml` to change the deployment process
   - Update scripts in `app/scripts/` to change deployment behavior

---

Created by Pravin Menghani with love for DevOps Automated Pipelines. Feel free to reach out at https://cloudcognoscente.com/contact for mentorship or any guidance.
