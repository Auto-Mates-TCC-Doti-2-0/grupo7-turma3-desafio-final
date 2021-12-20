variable "ami_id" {
  type = string
  description = "ami para criação dos nodes master e worker do cluster k8s"
}

variable "ssh_key_path" {
  type    = string
  default = "/home/ubuntu/.ssh/chave-privada.pem"
}

variable "db_environment" {
  type = map(string)
  description = "ambientes das instancias de banco de dados"
  default = {
    0 = "dev"
    1 = "stage"
    2 = "prod"
  }
}
