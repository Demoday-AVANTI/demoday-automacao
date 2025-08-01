variable "cluster_name" {
  default     = "demo-cluster"
  type        = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "partition" {
  description = "AWS partition (default: aws)"
  type        = string
  default     = "aws"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "create_security_group" {
  description = "Create a new security group for the node group"
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default     = "eks-nodes-sg"
}

variable "security_group_use_name_prefix" {
  description = "Use prefix for SG name"
  type        = bool
  default     = true
}

variable "security_group_ingress_rules" {
  description = "Ingress rules for SG"
  type        = any
  default     = {}
}

variable "security_group_egress_rules" {
  description = "Egress rules for SG"
  type        = any
  default     = {}
}

variable "iam_role_policy_statements" {
  description = "IAM inline policies for node role"
  type        = any
  default     = []
}

variable "create_iam_role_policy" {
  description = "Whether to create IAM role policies"
  type        = bool
  default     = true
}

variable "node_role_policy_arns" {
  description = "List of policy ARNs to attach to node IAM role"
  type        = list(string)
  default     = []
}