provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "dev_img_deploy_jenkins" {
  ami           = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.large"
  key_name      = var.key_id
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 15
  }
  tags = {
    Name = "wes_dev_img_deploy_jenkins"
  }
  vpc_security_group_ids = [aws_security_group.acesso_jenkins_dev_img.id]
}

resource "aws_security_group" "acesso_jenkins_dev_img" {
  name        = "wes_acesso_jenkins_dev_img"
  description = "acesso_jenkins_dev_img inbound traffic"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    # {
    #   description      = "SSH from VPC"
    #   from_port        = 80
    #   to_port          = 80
    #   protocol         = "tcp"
    #   cidr_blocks      = ["0.0.0.0/0"]
    #   ipv6_cidr_blocks = ["::/0"]
    #   prefix_list_ids  = null,
    #   security_groups : null,
    #   self : null
    # },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "wes-jenkins-dev-img-lab"
  }
}

# terraform refresh para mostrar o ssh
output "dev_img_deploy_jenkins" {
  value = [
    "resource_id: ${aws_instance.dev_img_deploy_jenkins.id}",
    "public_ip: ${aws_instance.dev_img_deploy_jenkins.public_ip}",
    "public_dns: ${aws_instance.dev_img_deploy_jenkins.public_dns}",
    "ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@${aws_instance.dev_img_deploy_jenkins.public_dns}"
  ]
}
