#!/usr/bin/env bash

# Script to build Docker image and push to ECR

# Require image name argument
if [ -z "$1" ]; then
  echo "Usage: $0 <IMAGE_NAME>"
  exit 1
fi


# Get the account number associated with the current IAM credentials
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [[ $? -ne 0 ]]
then
    exit 25
fi

AWS_DEFAULT_REGION=$(aws configure get region)

# Set variables 
IMAGE_NAME=$1
ECR_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_NAME}"
ECR_IMAGE="${ECR_REPO}:latest"

# Create ECR repo if needed
aws ecr describe-repositories --repository-names "${IMAGE_NAME}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  aws ecr create-repository --repository-name "${IMAGE_NAME}" > /dev/null
fi

# Login to ECR 
aws --region ${AWS_DEFAULT_REGION} ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

# Build and push image
echo "BUILDING IMAGE ${IMAGE_NAME}"
docker build -t "${IMAGE_NAME}" -f Dockerfile .
docker tag "${IMAGE_NAME}" "${ECR_IMAGE}"

echo "PUSHING IMAGE TO ECR ${ECR_IMAGE}"
docker push "${ECR_IMAGE}"