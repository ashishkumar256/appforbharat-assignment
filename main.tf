data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "insider-terraform-poc"
    key    = "prd-vpc"
    region = "ap-south-1"
  }
}

/*
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  subnet_ids_arn = split(",", "${data.terraform_remote_state.vpc.outputs.private_subnets_arn}")
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}
*/

module "codebuild" {
  source          = "./codebuild"
  name            = var.name
  environment     = var.environment
  region          = var.region
  vpc_id          = "${data.terraform_remote_state.vpc.outputs.id}"
  vpc_cidr        = "${data.terraform_remote_state.vpc.outputs.cidr}"
  private_subnets = "${data.terraform_remote_state.vpc.outputs.private_subnets}"
  private_subnets_arn = "${data.terraform_remote_state.vpc.outputs.private_subnets_arn}"
  code_source     = var.code_source
  github_repo     = var.github_repo 
  github_branch   = var.github_branch
  buildspec_path  = var.buildspec_path
  webhook         = var.webhook
  ecr_registry    = var.ecr_registry
}
