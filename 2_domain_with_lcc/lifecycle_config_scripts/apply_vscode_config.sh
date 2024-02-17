#!/bin/bash

# Navigate to config folder for VS Code
cd //opt/amazon/sagemaker/sagemaker-code-editor-server-data

# Copy config from an S3 bucket
aws s3 cp s3://vscode-config/config.zip .

# Overwrite current config with the downloaded one
unzip -o config.zip 

# Install dependencies
# pip install mlflow
