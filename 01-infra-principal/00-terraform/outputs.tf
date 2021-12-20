output "vpc_id" {
  description = "vpc id para ser utilizado nas demais esteiras"
  value = aws_vpc.vpc_main.id
}

output "pub_subnet_ids" {
  description = "subnet ids das redes publicas para serem utilizados nas demais esteiras"
  value = zipmap(range(length(local.pub_subnet_ids)), local.pub_subnet_ids)
}

output "priv_subnet_ids" {
  description = "subnet ids das redes publicas para serem utilizados nas demais esteiras"
  value =  zipmap(range(length(local.priv_subnet_ids)), local.priv_subnet_ids)
}

output "key_pair_name" {
  description = "nome do key pair criado para ser utilizado nas demais esteiras"
  value =  aws_key_pair.key_pair_grupo7.key_name
}

# terraform refresh para mostrar o ssh
output "ssh_pub_key_path" {
  sensitive = true
  description = "output para ser utilizado pelo script de destroy"
  value = var.ssh_pub_key_path
}

output "jenkins" {
  value = [
    "jenkins",
    "id: ${aws_instance.ec2_jenkins.id}",
    "private: ${aws_instance.ec2_jenkins.private_ip}",
    "public: ${aws_instance.ec2_jenkins.public_ip}",
    "public_dns: ${aws_instance.ec2_jenkins.public_dns}",
    "ssh -i ${trimsuffix(var.ssh_pub_key_path, ".pub")} ubuntu@${aws_instance.ec2_jenkins.public_dns}"
  ]
}