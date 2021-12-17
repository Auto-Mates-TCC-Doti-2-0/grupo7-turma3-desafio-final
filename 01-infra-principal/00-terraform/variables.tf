variable "subnet_pub_data" {
  type = map(any)
  default = {
    subnet1 = {
      cidr = "10.100.10.0/24"
      az   = "sa-east-1a"
    }
    subnet2 = {
      cidr = "10.100.11.0/24"
      az   = "sa-east-1b"
    }
    subnet3 = {
      cidr = "10.100.12.0/24"
      az   = "sa-east-1c"
    }
  }
}

variable "subnet_priv_data" {
  type = map(any)
  default = {
    subnet1 = {
      cidr = "10.100.1.0/24"
      az   = "sa-east-1a"
    }
    subnet2 = {
      cidr = "10.100.2.0/24"
      az   = "sa-east-1b"
    }
    subnet3 = {
      cidr = "10.100.3.0/24"
      az   = "sa-east-1c"
    }
  }
}

variable "ssh_pub_key_path" {
  type = string
}