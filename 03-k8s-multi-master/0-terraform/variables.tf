variable "ami_id" {
  type = string
  description = "ami para criação dos nodes master e worker do cluster k8s"
}

variable "ssh_key_path" {
  type    = string
  default = "/var/lib/jenkins/chave-privada.pem"
}

# variable key_pair_name {
#   type        = string
#   default     = "aws-turma3-gama-contini-dev"
# }

# variable subnet-az-a {
#   type        = map
#   default     = {
#     0 = "subnet-0392149021d220d31"
#     1 = "subnet-0392149021d220d31"
#     2 = "subnet-0392149021d220d31"
#   }
# }

# variable vpc_id {
#   type        = string
#   default     = "vpc-0a77aa83f8bc3de30"
#   description = "description"
# }
