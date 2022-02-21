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

variable "public_subnets" {
  description = "List of private subnets arn"
}

variable "ecr_registry" {
  description = "Ecr registry url for flask micro service"
}
