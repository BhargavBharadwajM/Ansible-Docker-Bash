#!/bin/bash

# Ensure correct number of arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: ./aws_resource_list.sh <aws_region> <aws_service>"
    echo "Example: ./aws_resource_list.sh us-east-1 ec2"
    exit 1
fi

# Assign the arguments to variables and convert the service to lowercase
aws_region=$1
aws_service=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# Check if the symbolic link exists
if [ ! -L /usr/local/bin/aws_install ]; then
    echo "Symbolic link for AWS CLI installation script not found."
    echo "Please run the installation script to set up the environment."
    exit 1
fi

# Execute the symbolic link script to ensure AWS CLI is installed and configured
/usr/local/bin/aws_install

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install the AWS CLI and try again."
    exit 1
fi

# Check if AWS is configured
if [ ! -d ~/.aws ]; then
    echo "AWS CLI is not configured. Please configure the AWS CLI and try again."
    exit 1
fi

# List the resources based on the service
case $aws_service in
    ec2)
        echo "Listing EC2 Instances in $aws_region"
        aws ec2 describe-instances --region "$aws_region"
        ;;
    rds)
        echo "Listing RDS Instances in $aws_region"
        aws rds describe-db-instances --region "$aws_region"
        ;;
    s3)
        echo "Listing S3 Buckets"
        aws s3api list-buckets
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions"
        aws cloudfront list-distributions
        ;;
    vpc)
        echo "Listing VPCs in $aws_region"
        aws ec2 describe-vpcs --region "$aws_region"
        ;;
    iam)
        echo "Listing IAM Users"
        aws iam list-users
        ;;
    route53)
        echo "Listing Route53 Hosted Zones"
        aws route53 list-hosted-zones
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in $aws_region"
        aws cloudwatch describe-alarms --region "$aws_region"
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in $aws_region"
        aws cloudformation describe-stacks --region "$aws_region"
        ;;
    lambda)
        echo "Listing Lambda Functions in $aws_region"
        aws lambda list-functions --region "$aws_region"
        ;;
    sns)
        echo "Listing SNS Topics"
        aws sns list-topics --region "$aws_region"
        ;;
    sqs)
        echo "Listing SQS Queues"
        aws sqs list-queues --region "$aws_region"
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables"
        aws dynamodb list-tables --region "$aws_region"
        ;;
    ebs)
        echo "Listing EBS Volumes in $aws_region"
        aws ec2 describe-volumes --region "$aws_region"
        ;;
    *)
        echo "Invalid service. Please enter a valid service from the list."
        exit 1
        ;;
esac
