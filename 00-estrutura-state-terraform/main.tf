provider "aws" {
    region = "sa-east-1"
}

resource "aws_s3_bucket" "bucket_remote_state" {
  bucket = "bucket-remote-state"
  acl    = "private"

  tags = {
    Name        = "bucket_remote_state"
    Environment = "Grupo7"
  }
}