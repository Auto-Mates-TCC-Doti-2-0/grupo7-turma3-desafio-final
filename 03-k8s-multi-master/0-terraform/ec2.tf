resource "aws_instance" "k8s_proxy" {
  count = 1

  ami                         = var.ami_id
  subnet_id                   = lookup(data.terraform_remote_state.infra_principal_remote_state.outputs.pub_subnet_ids, count.index)
  instance_type               = "t3.medium"
  key_name                    = data.terraform_remote_state.infra_principal_remote_state.outputs.key_pair_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.acessos_haproxy.id]

  tags = {
    Name = "k8s-haproxy"
    Group = "Grupo7"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 15
  }
}

resource "aws_instance" "k8s_masters" {
  count = 3 # não pode ser maior do que 3 - DT lógica de calculo das subnets

  ami                         = var.ami_id
  subnet_id                   = lookup(data.terraform_remote_state.infra_principal_remote_state.outputs.pub_subnet_ids, count.index)
  instance_type               = "t3.large"
  key_name                    = data.terraform_remote_state.infra_principal_remote_state.outputs.key_pair_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.acessos_masters.id]

  tags = {
    Name = "k8s-master-${count.index}"
    Group = "Grupo7"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 32
  }

  depends_on = [
    aws_instance.k8s_workers,
  ]
}

resource "aws_instance" "k8s_workers" {
  count = 3 # não pode ser maior do que 3 - DT lógica de calculo das subnets

  ami                         = var.ami_id
  subnet_id                   = lookup(data.terraform_remote_state.infra_principal_remote_state.outputs.pub_subnet_ids, count.index)
  instance_type               = "t3.medium"
  key_name                    = data.terraform_remote_state.infra_principal_remote_state.outputs.key_pair_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.acessos_workers.id]

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 32
  }

  tags = {
    Name = "k8s_workers-${count.index}"
    Group = "Grupo7"
  }
}

# locals {

#   k8s_master_hostname = [for item in aws_instance.k8s_proxy : item.public_dns]
#   k8s_master_dns = [for item in aws_instance.k8s_proxy : item.public_dns]
  
#   k8s_worker_hostname = [for item in aws_instance.k8s_proxy : item.public_dns]
#   k8s_worker_dns = [for item in aws_instance.k8s_proxy : item.public_dns]

#   k8s_proxy_dns = [for item in aws_instance.k8s_proxy : item.public_dns]

#   ansible_hosts = <<ANSIBLEHOSTS


#     [ec2-k8s-proxy]
#     ${join("\n", local.k8s_proxy_dns)}
#     ANSIBLEHOSTS

# }
# resource "local_file" "ansible_hosts"{
#     filename = "../01-ansible/hosts"
#     content = local.ansible_hosts
# }