resource "aws_ami_from_instance" "template-ami" {
  name               = "template-ami-${var.versao}"
  source_instance_id = var.resource_id

  tags = {
    Name = "template-ami-${var.versao}"
    Group = "Grupo7"
  }
}

output "ami" {
  value = [
    "AMI_ID: ${aws_ami_from_instance.template-ami.id}"
  ]
}
