resource "aws_instance" "mysql" {
  for_each = var.db_environment

  ami                         = var.ami_id
  subnet_id                   = lookup(data.terraform_remote_state.infra_principal_remote_state.outputs.pub_subnet_ids, each.key)
  instance_type               = "t3.medium"
  key_name                    = data.terraform_remote_state.infra_principal_remote_state.outputs.key_pair_name
  associate_public_ip_address = true

  tags = {
    Name = "ec2-mysql-${each.value}"
    Group = "Grupo7"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 15
  }
  vpc_security_group_ids = [aws_security_group.acessos_mysql.id]
}