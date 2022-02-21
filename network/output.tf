output "id" {
  value = module.vpc.id
}

output "cidr" {
  value = var.cidr
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_dms_subnets" {
  value = module.vpc.private_dms_subnets 
}

output "public_subnets_arn" {
  value = module.vpc.public_subnets_arn
}

output "private_subnets_arn" {
  value = module.vpc.private_subnets_arn
}

output "private_dms_subnets_arn" {
  value = module.vpc.private_dms_subnets_arn
}

