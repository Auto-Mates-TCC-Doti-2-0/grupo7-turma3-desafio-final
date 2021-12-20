output "ami_id" {
  value = var.ami_id
}

output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master ${key+1} - ${item.private_ip} - ssh -i ${var.ssh_key_path} ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
      "k8s-workers ${key+1} - ${item.private_ip} - ssh -i ${var.ssh_key_path} ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_proxy" {
  value = [
    for key, item in aws_instance.k8s_proxy :
      "k8s_proxy ${key+1} - ${item.private_ip} - ssh -i ${var.ssh_key_path} ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}