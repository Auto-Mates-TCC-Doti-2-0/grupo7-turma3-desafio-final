terraform {
  backend "s3" {
    bucket  = "bucket-remote-state"
    key     = "04-mysql.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}