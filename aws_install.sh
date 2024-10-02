#!/bin/bash

# Error handling function
handle_error() {
    echo "Error occurred: $1"
    exit 1
}

# Check if AWS CLI is already installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Installing AWS CLI..."
    
    # Download and install AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" || handle_error "Failed to download AWS CLI"
    unzip awscliv2.zip || handle_error "Failed to unzip AWS CLI package"
    sudo ./aws/install --update || handle_error "Failed to install AWS CLI"
    rm -rf aws awscliv2.zip
    echo "AWS CLI installed successfully."

    # Add AWS CLI to PATH
    export PATH=/usr/local/bin:$PATH
    echo "Added AWS CLI to PATH."

    # Refresh the shell's command hash to recognize the new AWS CLI
    hash -r
else
    echo "AWS CLI is already installed."
fi

# Hardcoded AWS configuration details
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_DEFAULT_REGION=""
AWS_DEFAULT_OUTPUT_FORMAT=""

# Configure AWS CLI
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" || handle_error "Failed to configure AWS Access Key"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" || handle_error "Failed to configure AWS Secret Key"
aws configure set default.region "$AWS_DEFAULT_REGION" || handle_error "Failed to configure AWS Region"
aws configure set default.output "$AWS_DEFAULT_OUTPUT_FORMAT" || handle_error "Failed to configure AWS Output Format"

echo "AWS CLI configured successfully."
