terraform {
  backend "s3" {
    bucket  = "bucket-remote-state"
    key     = "02-k8s-multi-master.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}