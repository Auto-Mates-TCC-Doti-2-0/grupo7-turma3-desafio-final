terraform {
  backend "s3" {
    bucket  = "bucket-remote-state"
    key     = "01-infra-principal.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}