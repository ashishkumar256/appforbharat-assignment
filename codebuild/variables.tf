variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "AWS region id for aws codebuild"
}

variable "vpc_id" {
  description = "Vpc where codebuild instance will run"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "private_subnets_arn" {
  description = "List of private subnets arn"
}

variable "code_source" {
  description = "codebase source"
}


variable "github_repo" {
  description = "Github https repo url"
}


variable "github_branch" {
  description = "Github repo branch"
}


variable "buildspec_path" {
  description = "Path to buildspec.yml path"
}

variable "webhook" {
  description = "Specify whether triggering new build on commit"
}

variable "ecr_registry" {
  description = "Ecr registry url for flask micro service"
  default     = "enabled"
}
