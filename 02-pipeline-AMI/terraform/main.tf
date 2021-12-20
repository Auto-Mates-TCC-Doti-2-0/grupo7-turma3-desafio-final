data "aws_ami" "ami_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}


resource "aws_instance" "dev_img_deploy_template" {
  ami                         = data.aws_ami.ami_ubuntu.id
  instance_type               = "t2.large"
  key_name                    = data.terraform_remote_state.infra_principal_remote_state.outputs.key_pair_name
  subnet_id                   = lookup(data.terraform_remote_state.infra_principal_remote_state.outputs.pub_subnet_ids, 0)
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 15
  }
  tags = {
    Name = "ec2_ami_template"
  }
  vpc_security_group_ids = [aws_security_group.acesso_template_dev_img.id]
}

resource "aws_security_group" "acesso_template_dev_img" {
  name        = "acesso_template_dev_img"
  description = "acesso_template_dev_img inbound traffic"
  vpc_id      = data.terraform_remote_state.infra_principal_remote_state.outputs.vpc_id

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
    Name = "template-dev-img"
  }
}

# terraform refresh para mostrar o ssh
output "dev_img_deploy_template" {
  value = [
    "resource_id: ${aws_instance.dev_img_deploy_template.id}",
    "public_ip: ${aws_instance.dev_img_deploy_template.public_ip}",
    "public_dns: ${aws_instance.dev_img_deploy_template.public_dns}",
    "ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.dev_img_deploy_template.public_dns}"
  ]
}
