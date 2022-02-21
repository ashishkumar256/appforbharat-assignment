variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  default     = "demo"
}

variable "environment" {
  description = "the name of your environment, e.g. \"dev, stg, uat, prd\""
  default     = "prd"
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "ap-south-1"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.0.0/18", "10.0.64.0/18", "10.0.128.0/18"]
}

variable "private_dms_subnets" {
  description = "a list of CIDRs for private_dms subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.200.0/21", "10.0.208.0/21", "10.0.216.0/21"]
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.232.0/21", "10.0.240.0/21", "10.0.248.0/21"]
}

variable "kubeconfig_path" {
  description = "Path where the config file for kubectl should be written to"
  default     = "~/.kube"
}

variable "k8s_version" {
  description = "kubernetes version"
  default = ""
}
