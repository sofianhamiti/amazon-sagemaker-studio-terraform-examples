#!/usr/bin/env bash

# Create ECR repo if needed
aws ecr describe-repositories --repository-names "${IMAGE_NAME}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  aws ecr create-repository --repository-name "${IMAGE_NAME}" > /dev/null
fi

# Login to ECR 
aws --region ${AWS_REGION} ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Build and push image
echo "BUILDING IMAGE ${IMAGE_NAME}"
# docker build -t "${IMAGE_NAME}" -f Dockerfile .
docker build -t "${IMAGE_NAME}" -f Dockerfile . --network sagemaker
docker tag "${IMAGE_NAME}" "${ECR_IMAGE}"

echo "PUSHING IMAGE TO ECR ${ECR_IMAGE}"
docker push "${ECR_IMAGE}"