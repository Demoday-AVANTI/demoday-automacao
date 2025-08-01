provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name   = "ex-eks-mng"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.5"

  name               = var.cluster_name
  kubernetes_version = "1.30"  # ✅ CORREÇÃO: versão estável com AMIs disponíveis

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets  # ✅ CORREÇÃO: usar subnets privadas

  # Habilitar IRSA (crucial para IAM Roles for Service Accounts)
  enable_irsa = true

  # Node Group Gerenciado (EKS-managed)
  eks_managed_node_groups = {
    default = {
      name = "ng-default"

      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      # ✅ CORREÇÃO: usar AMI type mais estável
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"

      # ✅ CORREÇÃO: adicionar configurações de disco
      disk_size = 20

      # Labels Kubernetes
      labels = {
        environment = "dev"
        nodegroup   = "default"
      }

      # Política adicional: se precisar de acesso a S3, ECR, etc.
      additional_iam_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      ]

      # ✅ CORREÇÃO: adicionar configurações de update
      update_config = {
        max_unavailable = 1
      }
    }
  }

  # Habilitar logs do cluster
  # cluster_loggins = ["api", "audit", "scheduler", "controllerManager"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Project     = "monitoramento-climatico"
  }
}