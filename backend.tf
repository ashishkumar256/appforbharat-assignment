terraform {
  backend "s3" {
    bucket = "insider-terraform-poc"
    key    = "demo"
    region = "ap-south-1"
  }
}
