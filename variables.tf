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

variable "code_source" {
  description = "codebase source"
  default =  "GITHUB"
}

variable "github_repo" {
  description = "Github https repo url"
  default     = "https://github.com/ashishkumar256/appforbharat-assignment.git"
}


variable "github_branch" {
  description = "Github repo branch"
  default     = "master"
}

variable "buildspec_path" {
  description = "Path to buildspec.yml path"
  default = "buildspec.yml"
}

variable "webhook" {
  description = "Specify whether triggering new build on commit"
  default     = "enabled"
}


variable "ecr_registry" {
  description = "Ecr registry url for flask micro service"
  default     = "626668625088.dkr.ecr.ap-south-1.amazonaws.com/test"
}
