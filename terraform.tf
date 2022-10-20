terraform {
  backend "s3" {
    bucket         = "my-tf-remote-backend-1111222233330000"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-remote-backend"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.35.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
