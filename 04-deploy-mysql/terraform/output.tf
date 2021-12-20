output "instancias_mysql" {
  value = [
    for item in aws_instance.mysql :
      "${item.tags.Name} - ${item.private_ip} - ssh -i ${var.ssh_key_path} ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "ami_id" {
  value = var.ami_id
}
