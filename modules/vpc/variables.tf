variable "cidr_block" {
  type        = string
  description = "CIDR block for SageMaker VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
}