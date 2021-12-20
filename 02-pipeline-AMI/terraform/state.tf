terraform {
  backend "s3" {
    bucket  = "bucket-remote-state"
    key     = "02-provisiona-infra-pipeline-AMI.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}