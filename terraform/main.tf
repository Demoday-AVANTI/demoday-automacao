# Zonas de disponibilidade
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC com sub-redes públicas
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnets = []

  enable_nat_gateway     = false
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  tags = {
    Name = "eks-vpc"
  }
}

# Cluster EKS + Node Group
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.5"

  name               = var.cluster_name
  kubernetes_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  # Node Group
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      ami_type      = "AL2_x86_64"
      capacity_type = "ON_DEMAND"

      disk_size = 20

      additional_iam_policies = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      ]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}