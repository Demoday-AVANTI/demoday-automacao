variable "cluster_name" {
  default     = "demo-cluster"
  type        = string
}

variable "aws_region" {
  default     = "us-east-1"
  type        = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
}