terraform {
  backend "s3" {
    bucket = "insider-terraform-poc"
    key    = "demo-codebuild"
    region = "ap-south-1"
  }
}
