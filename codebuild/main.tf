provider "aws" {
  region  = "ap-south-1"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "insider-terraform-poc"
    key    = "prd-vpc"
    region = "ap-south-1"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  subnet_ids_arn = split(",", "${data.terraform_remote_state.vpc.outputs.private_subnets_arn}")
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}

output "x" {
  value = local.subnet_ids_arn
}

resource "aws_iam_role" "demo" {
  name = "demo"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "demo" {
  role = aws_iam_role.demo.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.demo.arn}",
        "${aws_s3_bucket.demo.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": [
        "arn:aws:ec2:${local.aws_region}:${local.aws_account_id}:network-interface/*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:Subnet": [
            "arn:aws:ec2:ap-south-1:626668625088:subnet/subnet-091a43da27f199e7b",
            "arn:aws:ec2:ap-south-1:626668625088:subnet/subnet-0cb7ffe598b1fbcf9",
            "arn:aws:ec2:ap-south-1:626668625088:subnet/subnet-07f6c8906a013facb"
          ],
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    }, 
    {
      "Effect": "Allow",
      "Action": [
          "ecr:*",
          "cloudtrail:LookupEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "iam:CreateServiceLinkedRole"
      ],
      "Resource": "*",
      "Condition": {
          "StringEquals": {
              "iam:AWSServiceName": [
                  "replication.ecr.amazonaws.com"
              ]
          }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
          "ssm:DescribeParameters"
      ],
      "Resource": "*"
    },
   {
      "Effect": "Allow",
      "Action": [
          "ssm:GetParameters"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "demo" {
  bucket = "codebuild-${local.aws_account_id}-logs"
}

resource "aws_s3_bucket_acl" "demo" {
  bucket = aws_s3_bucket.demo.id
  acl    = "private"
}

resource "aws_security_group" "codebuild_sg" {
  name        = "codebuild-sg"
  description = "Allow TLS inbound traffic"
  vpc_id     = "${data.terraform_remote_state.vpc.outputs.id}"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "codebuild-sg"
  }
}




resource "aws_codebuild_project" "demo" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.demo.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
    
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.demo.id}/build-log"
    } 
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/ashishkumar256/appforbharat-assignment.git"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

  
  vpc_config {
    vpc_id = "${data.terraform_remote_state.vpc.outputs.id}"

    subnets = split(",", "${data.terraform_remote_state.vpc.outputs.private_subnets}")
    
    security_group_ids = [
      aws_security_group.codebuild_sg.id,
    ]
    
  } 

  tags = {
    Environment = "Test"
  }
}



resource "aws_codebuild_webhook" "demo" {
  project_name = aws_codebuild_project.demo.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
}


