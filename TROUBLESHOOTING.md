# CI/CD Pipeline Troubleshooting Guide

This guide provides solutions for common issues you might encounter when setting up and running the CI/CD pipeline.

## Table of Contents

1. [CloudFormation Deployment Issues](#cloudformation-deployment-issues)
2. [CodePipeline Issues](#codepipeline-issues)
3. [CodeBuild Issues](#codebuild-issues)
4. [CodeDeploy Issues](#codedeploy-issues)
5. [EC2 and Auto Scaling Issues](#ec2-and-auto-scaling-issues)
6. [Load Balancer Issues](#load-balancer-issues)
7. [Application Issues](#application-issues)

## CloudFormation Deployment Issues

### Stack Creation Fails

**Symptoms:**
- CloudFormation stack shows CREATE_FAILED status
- Error message in the Events tab

**Possible Causes and Solutions:**

1. **Insufficient Permissions**
   - **Error:** "User: [ARN] is not authorized to perform: [action]"
   - **Solution:** Ensure your IAM user or role has sufficient permissions to create all resources in the template

2. **Resource Already Exists**
   - **Error:** "Resource already exists"
   - **Solution:** Delete the existing resource or use a different name for your resources

3. **Service Limits Exceeded**
   - **Error:** "The maximum number of [resource] has been reached"
   - **Solution:** Request a service limit increase or delete unused resources

4. **Invalid Template**
   - **Error:** "Template format error"
   - **Solution:** Validate your CloudFormation template using the AWS CLI:
     ```bash
     aws cloudformation validate-template --template-body file://template.yml
     ```

### Stack Update Fails

**Symptoms:**
- CloudFormation stack shows UPDATE_ROLLBACK_COMPLETE status
- Changes not applied

**Possible Causes and Solutions:**

1. **Protected Resources**
   - **Error:** "Update requires replacement of resource that cannot be replaced"
   - **Solution:** Some resources cannot be updated and require replacement. Consider creating a new stack.

2. **Dependency Issues**
   - **Error:** "Dependency violation"
   - **Solution:** Ensure resources are updated in the correct order. Check resource dependencies.

## CodePipeline Issues

### Pipeline Does Not Start Automatically

**Symptoms:**
- Changes pushed to GitHub but pipeline doesn't start
- Pipeline status remains unchanged

**Possible Causes and Solutions:**

1. **Webhook Configuration**
   - **Issue:** GitHub webhook not properly configured
   - **Solution:** Check webhook settings in GitHub repository settings

2. **OAuth Token Expired**
   - **Issue:** GitHub OAuth token is invalid or expired
   - **Solution:** Generate a new token and update the pipeline:
     ```bash
     aws codepipeline update-pipeline --cli-input-json file://pipeline-config.json
     ```

3. **Branch Mismatch**
   - **Issue:** Pushing to a branch that's not monitored by the pipeline
   - **Solution:** Ensure you're pushing to the correct branch (e.g., main)

### Pipeline Fails at Source Stage

**Symptoms:**
- Source stage shows "Failed"
- Error about GitHub access

**Possible Causes and Solutions:**

1. **Invalid OAuth Token**
   - **Error:** "Failed to access the repository"
   - **Solution:** Update the GitHub OAuth token in the pipeline configuration

2. **Repository Not Found**
   - **Error:** "Repository not found"
   - **Solution:** Verify the repository owner and name are correct

## CodeBuild Issues

### Build Fails

**Symptoms:**
- Build stage shows "Failed"
- Error in the build logs

**Possible Causes and Solutions:**

1. **Missing buildspec.yml**
   - **Error:** "Unable to locate buildspec.yml"
   - **Solution:** Ensure buildspec.yml exists in the root of your repository

2. **Invalid buildspec.yml**
   - **Error:** "Invalid buildspec.yml file"
   - **Solution:** Validate your buildspec.yml format

3. **Build Command Failures**
   - **Error:** Specific command errors in the build logs
   - **Solution:** Check the build logs for the specific command that failed and fix the issue

4. **Missing Files**
   - **Error:** "cp: cannot stat '*.html': No such file or directory"
   - **Solution:** Ensure the files referenced in the build commands exist in the repository

5. **Insufficient Permissions**
   - **Error:** "Access denied" or "Permission denied"
   - **Solution:** Check the CodeBuild service role permissions

### Build Takes Too Long

**Symptoms:**
- Build stage takes a long time to complete
- Timeout errors

**Possible Causes and Solutions:**

1. **Inefficient Build Process**
   - **Solution:** Optimize your build commands and use caching

2. **Insufficient Resources**
   - **Solution:** Increase the build environment compute type

## CodeDeploy Issues

### Deployment Fails

**Symptoms:**
- Deploy stage shows "Failed"
- Error in the deployment logs

**Possible Causes and Solutions:**

1. **CodeDeploy Agent Not Installed**
   - **Error:** "The CodeDeploy agent was not found"
   - **Solution:** Ensure the CodeDeploy agent is installed and running on the instances:
     ```bash
     sudo service codedeploy-agent status
     sudo service codedeploy-agent restart
     ```

2. **Invalid appspec.yml**
   - **Error:** "Invalid appspec.yml file"
   - **Solution:** Validate your appspec.yml format

3. **Deployment Script Errors**
   - **Error:** Specific script errors in the deployment logs
   - **Solution:** Check the deployment logs for the specific script that failed and fix the issue

4. **Instance Health Issues**
   - **Error:** "No healthy instances in the deployment group"
   - **Solution:** Check the health of your EC2 instances in the Auto Scaling Group

### Deployment Succeeds but Application Not Working

**Symptoms:**
- Deploy stage shows "Succeeded"
- Application not accessible or showing errors

**Possible Causes and Solutions:**

1. **File Permission Issues**
   - **Solution:** Check file permissions in the deployment directory:
     ```bash
     sudo ls -la /var/www/html/
     sudo chmod -R 755 /var/www/html/
     ```

2. **Apache Configuration Issues**
   - **Solution:** Check Apache status and configuration:
     ```bash
     sudo systemctl status apache2
     sudo cat /var/log/apache2/error.log
     ```

## EC2 and Auto Scaling Issues

### Instances Fail to Launch

**Symptoms:**
- Auto Scaling Group shows failed launch attempts
- No instances or fewer instances than expected

**Possible Causes and Solutions:**

1. **AMI Not Available**
   - **Error:** "The image id '[ami-id]' does not exist"
   - **Solution:** Update the AMI ID in the launch template

2. **Instance Type Not Available**
   - **Error:** "The requested instance type is not supported in the requested Availability Zone"
   - **Solution:** Choose a different instance type or availability zone

3. **Insufficient Capacity**
   - **Error:** "Insufficient capacity"
   - **Solution:** Try a different instance type or wait and retry

4. **User Data Script Failures**
   - **Solution:** Check the system log of a failed instance for user data script errors

### Instances Unhealthy

**Symptoms:**
- Instances marked as unhealthy in the Auto Scaling Group
- Instances being terminated and replaced

**Possible Causes and Solutions:**

1. **Failed Health Checks**
   - **Solution:** Check the health check configuration and ensure your application responds correctly

2. **High CPU or Memory Usage**
   - **Solution:** Check instance metrics and optimize your application

## Load Balancer Issues

### Target Group Unhealthy

**Symptoms:**
- Targets in the target group marked as unhealthy
- Application not accessible via load balancer

**Possible Causes and Solutions:**

1. **Health Check Path Not Available**
   - **Solution:** Ensure the health check path exists and returns a 200 status code

2. **Security Group Issues**
   - **Solution:** Verify that the security groups allow traffic between the load balancer and instances

3. **Application Not Running**
   - **Solution:** Check if Apache is running on the instances:
     ```bash
     sudo systemctl status apache2
     ```

## Application Issues

### Application Not Accessible

**Symptoms:**
- Cannot access the application via the load balancer URL
- Browser shows connection timeout or error

**Possible Causes and Solutions:**

1. **DNS Propagation**
   - **Solution:** Wait a few minutes for DNS to propagate

2. **Security Group Configuration**
   - **Solution:** Ensure the load balancer security group allows inbound traffic on port 80

3. **Application Not Running**
   - **Solution:** Check if the application is running on the instances

### Application Shows Errors

**Symptoms:**
- Application loads but shows errors
- Functionality not working as expected

**Possible Causes and Solutions:**

1. **JavaScript Errors**
   - **Solution:** Check the browser console for JavaScript errors

2. **Missing Files**
   - **Solution:** Verify all required files were deployed correctly

3. **Server-Side Errors**
   - **Solution:** Check Apache error logs:
     ```bash
     sudo cat /var/log/apache2/error.log
     ```

## Getting Additional Help

If you're still experiencing issues after trying these troubleshooting steps, consider:

1. **AWS Support**: If you have an AWS support plan, open a support case
2. **AWS Forums**: Post your question on the [AWS Developer Forums](https://forums.aws.amazon.com/)
3. **Stack Overflow**: Ask a question on Stack Overflow with the appropriate AWS tags
4. **GitHub Issues**: If it's related to the repository code, open an issue on GitHub

---

Created by Pravin Menghani with love for DevOps Automated Pipelines. Feel free to reach out at https://cloudcognoscente.com/contact for mentorship or any guidance.
