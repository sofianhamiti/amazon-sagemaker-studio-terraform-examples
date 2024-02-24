#!/bin/bash

# Add less for AWCLI
apt-get update && apt-get install -yy less

# Making sure the sagemaker-user folder has the correct permissions
cd /home
chmod -R 755 sagemaker-user

# Navigate to config folder for VS Code
cd //opt/amazon/sagemaker/sagemaker-code-editor-server-data

# Copy config from an S3 bucket
# You can copy your current VS Code config from //opt/amazon/sagemaker/sagemaker-code-editor-server-data and upload it to S3. 
# Here we zipped the folder, uploaded to an S3 bucket, and use the LCC to apply the config to all VS Code environments.
aws s3 cp s3://vscode-config/config.zip .

# Overwrite current config with the downloaded one
unzip -o config.zip 

# Install dependencies
# pip install mlflow
