terraform {
  backend "s3" {
    bucket = "my-tf-remote-backend-1111222233330000"
    key = "global/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "my-remote-backend"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.35.0"
    }
  }
}
