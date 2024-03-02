#!/bin/bash

# Add less for AWCLI
sudo apt-get update && sudo apt-get install -yy less

# Making sure the sagemaker-user folder has the correct permissions
cd /home
chmod -R 755 sagemaker-user

# Install dependencies
pip install mlflow
