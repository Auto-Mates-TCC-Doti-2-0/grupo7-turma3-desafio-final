variable key_pair_name {
  type        = string
  default     = "aws-turma3-gama-contini-dev"
}

variable subnet-az-a {
  type        = string
  default     = "subnet-0392149021d220d31"
}

variable vpc_id {
  type        = string
  default     = "vpc-0a77aa83f8bc3de30"
  description = "description"
}

variable meu_nome {
  type        = string
  default     = "contini"
  description = "Adicionar seu nome"
}

variable "ssh_key_path" {
  type    = string
  default = "~/.ssh/id_rsa"
}
