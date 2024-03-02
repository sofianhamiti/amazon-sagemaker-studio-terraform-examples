data "aws_region" "current" {}

# VPC
# This block configures various settings for the VPC,
# such as the name, CIDR block, availability zones, public and private subnets, NAT gateways,
# DNS settings, and security group/network ACL management.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name                          = "sagemaker-vpc"
  cidr                          = var.cidr_block
  azs                           = var.availability_zones
  private_subnets               = var.private_subnet_cidrs
  public_subnets                = var.public_subnet_cidrs
  enable_nat_gateway            = true
  single_nat_gateway            = false
  one_nat_gateway_per_az        = true
  enable_vpn_gateway            = false
  enable_dns_hostnames          = true
  enable_dns_support            = true
  manage_default_security_group = false
  manage_default_network_acl    = false
}

# Security Group for User Profiles
# This resource creates a security group for SageMaker user profiles. It allows all outbound traffic from the security group.
resource "aws_security_group" "sagemaker_sg" {
  name   = "sagemaker_user_sg"
  vpc_id = module.vpc.vpc_id

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow NFS traffic for EFS"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Security Group for VPC Endpoints
# This resource creates a security group for VPC endpoints. 
# It allows incoming connections on port 443 from within the VPC and all outbound traffic from the security group.
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "sagemaker_vpc_endpoint_sg"
  description = "Allow incoming connections on port 443 from VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow incoming connections on port 443 from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# VPC Endpoints for SageMaker APIs
# This resource creates VPC interface endpoints for various SageMaker APIs, 
# such as SageMaker API, SageMaker Runtime, Service Catalog, CloudWatch Logs, and AWS STS. 
# It associates the endpoints with the private subnets and the VPC endpoint security group.
resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = toset([
    "com.amazonaws.${data.aws_region.current.name}.sagemaker.api",
    "com.amazonaws.${data.aws_region.current.name}.sagemaker.runtime",
    "com.amazonaws.${data.aws_region.current.name}.servicecatalog",
    "com.amazonaws.${data.aws_region.current.name}.logs",
    "com.amazonaws.${data.aws_region.current.name}.sts",
  ])

  vpc_id              = module.vpc.vpc_id
  service_name        = each.key
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
}

# VPC Gateway Endpoint for S3
# This module creates a VPC gateway endpoint for Amazon S3. 
# It associates the endpoint with the private route tables and the VPC endpoint security group.
module "endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.5.1"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  endpoints = {
    s3 = {
      service         = "s3"
      route_table_ids = module.vpc.private_route_table_ids
    }
  }
}