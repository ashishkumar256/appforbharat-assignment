terraform {
  backend "s3" {
    bucket = "insider-terraform-poc"
    key    = "prd-vpc"
    region = "ap-south-1"
  }
}
