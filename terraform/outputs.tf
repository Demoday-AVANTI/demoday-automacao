output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_name
}

output "cluster_certificate_authority_data" {
  description = "Certificado do cluster"
  value       = module.eks.cluster_certificate_authority_data
}