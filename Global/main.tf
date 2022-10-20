provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "remote_backend" {
  bucket = "my-tf-remote-backend-1111222233330000"
}

resource "aws_dynamodb_table" "remote-backend" {
  name           = "my-remote-backend"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
