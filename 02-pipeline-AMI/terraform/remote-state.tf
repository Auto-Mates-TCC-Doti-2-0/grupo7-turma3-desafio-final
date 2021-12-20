data "terraform_remote_state" "infra_principal_remote_state" {
  backend = "s3"
  config = {
    bucket  = "bucket-remote-state"
    key     = "01-infra-principal.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}