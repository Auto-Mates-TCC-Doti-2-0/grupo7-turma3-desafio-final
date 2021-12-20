locals {

  pub_subnet_ids = [for subnet in aws_subnet.subnet_pub : subnet.id]

  priv_subnet_ids = [for subnet in aws_subnet.subnet_priv : subnet.id]

}