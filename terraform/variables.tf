variable "region" {
  description = "Região AWS"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  default     = "cluster"
}

variable "vpc_cidr" {
  description = "CIDR da VPC"
  default     = "10.0.0.0/16"
}