data "aws_ami" "ami_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}


resource "aws_instance" "ec2_jenkins" {
  ami           = data.aws_ami.ami_ubuntu.id
  instance_type = "t2.large"
  subnet_id = aws_subnet.subnet_pub["subnet1"].id
  key_name      = aws_key_pair.key_pair_grupo7.key_name
  # iam_instance_profile = "aws-cli-ec2" # Necessário associar manualmente via painel
  associate_public_ip_address = true
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 32
  }
  tags = {
    Name = "ec2_grupo7_jenkins"
    Grupo = "Grupo7"
  }
  vpc_security_group_ids = ["${aws_security_group.sg_jenkins.id}"]
}

resource "aws_security_group" "sg_jenkins" {
  name        = "sg1_grupo7_jenkins"
  description = "Allow inbound traffic to jenkins server and URL"
  vpc_id = aws_vpc.vpc_main.id

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
    {
      description      = "HTTP access"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
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
    Name = "sg1_grupo7_jenkins"
  }
}

resource "local_file" "ansible_hosts"{
    filename = "../01-ansible/hosts"
    content = <<ANSIBLEHOSTS
    [ec2-jenkins]
    ${aws_instance.ec2_jenkins.public_dns}
    ANSIBLEHOSTS
}
