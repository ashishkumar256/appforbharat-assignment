module "vpc" {
  source             = "./vpc"
  name               = var.name
  environment        = var.environment
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  private_dms_subnets    = var.private_dms_subnets  
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}
