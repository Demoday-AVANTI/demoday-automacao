variable "cluster_name" {
  description = "The name for the EKS cluster"
  default     = "demo-cluster"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}