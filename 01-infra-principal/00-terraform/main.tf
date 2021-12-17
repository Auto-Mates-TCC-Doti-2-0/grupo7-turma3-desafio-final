resource "aws_vpc" "vpc_main" {
  cidr_block           = "10.100.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name  = "vpc_main"
    Group = "Grupo7"
  }
}

### Subnets publicas
resource "aws_subnet" "subnet_pub" {
  for_each = var.subnet_pub_data

  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name  = "${each.key}_pub"
    Group = "Grupo7"
  }
}

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name  = "igw_main"
    Group = "Grupo7"
  }
}

resource "aws_route_table" "igw_rtb_main" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main.id
  }

  tags = {
    Name  = "rtb_igw_main"
    Group = "Grupo7"
  }
}

resource "aws_route_table_association" "rtb_association_igw_pub_subnets" {
  for_each = aws_subnet.subnet_pub

  subnet_id      = each.value.id
  route_table_id = aws_route_table.igw_rtb_main.id
}

### Subnets privadas
resource "aws_subnet" "subnet_priv" {
  for_each = var.subnet_priv_data

  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name  = "${each.key}_priv"
    Group = "Grupo7"
  }
}

resource "aws_eip" "eip_natgw" {
  for_each = aws_subnet.subnet_priv
  vpc      = true

  tags = {
    Name  = "eip_natgw_${trimprefix(each.key, "subnet")}"
    Group = "Grupo7"
  }
}

resource "aws_nat_gateway" "natgw_main" {
  for_each = aws_subnet.subnet_priv

  allocation_id = aws_eip.eip_natgw[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name  = "natgw_main_${trimprefix(each.key, "subnet")}"
    Group = "Grupo7"
  }
}

### SSH Keypair
resource "aws_key_pair" "key_pair_grupo7" {
  key_name   = "key_pair_grupo7"
  public_key = file(var.ssh_pub_key_path)

  tags = {
    Name  = "key_pair_grupo7"
    Group = "Grupo7"
  }
}
