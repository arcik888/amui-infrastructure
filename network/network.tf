# VPC
resource "aws_vpc" "amui_vpc" {
  cidr_block           = "32.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name     = "AMUI VPC ${var.vpc_name}-${var.customer_short}"
  }
}

# AWS Public Subnets for VPC
resource "aws_subnet" "amui_public_subnet" {
  for_each = toset(var.azs)
  vpc_id = aws_vpc.amui_vpc.id
  cidr_block = "32.0.${index(var.azs, each.value) + 1}.0/27"
  map_public_ip_on_launch = true
  availability_zone = each.value

  tags = {
    Name              = "AMUI VPC Public subnet ${var.vpc_name}-${var.customer_short}"
  }
}

# AWS Private Subnets for VPC
resource "aws_subnet" "amui_private_subnet" {
  for_each = toset(var.azs)
  vpc_id = aws_vpc.amui_vpc.id
  cidr_block = "32.0.${index(var.azs, each.value) + 10}.0/24"
  map_public_ip_on_launch = false
  availability_zone = each.value

  tags = {
    Name              = "AMUI VPC Private subnet 1 ${var.vpc_name}-${var.customer_short}"
  }
}

# AWS Internet Gateway, Route table, Association
resource "aws_internet_gateway" "amui_igw" {
  vpc_id = aws_vpc.amui_vpc.id
}

resource "aws_route_table" "amui_public_rt" {
  vpc_id = aws_vpc.amui_vpc.id
  route {
    gateway_id = aws_internet_gateway.amui_igw.id
    cidr_block = var.general_cidr_block
  }
}

resource "aws_route_table_association" "amui_public_rt_associate" {
  for_each = toset(var.azs)
  subnet_id      = aws_subnet.amui_public_subnet[each.value].id
  route_table_id = aws_route_table.amui_public_rt.id
}

# # NAT gateway
resource "aws_eip" "amui_nat_eip" {
  for_each = toset(var.azs)
  vpc = true

  tags = {
    Name = "Private Subnet 1 NAT gateway ${var.vpc_name}-${var.customer_short}"
  }
}

resource "aws_nat_gateway" "amui_nat_gw" {
  for_each = toset(var.azs)
  connectivity_type = "public"
  allocation_id     = aws_eip.amui_nat_eip[each.value].id
  subnet_id         = aws_subnet.amui_public_subnet[each.value].id
  depends_on = [
    aws_eip.amui_nat_eip,
    aws_internet_gateway.amui_igw
  ]

  tags = {
    Name = "Private Subnet 1 NAT gateway ${var.vpc_name}-${var.customer_short}"
  }
}

resource "aws_route_table" "amui_private_rt" {
  for_each = toset(var.azs)
  vpc_id = aws_vpc.amui_vpc.id
  route {
    nat_gateway_id = aws_nat_gateway.amui_nat_gw[each.value].id
    cidr_block     = var.general_cidr_block
  }
}

resource "aws_route_table_association" "amui_private1_rt_associate" {
  for_each = toset(var.azs)
  subnet_id      = aws_subnet.amui_private_subnet[each.value].id
  route_table_id = aws_route_table.amui_private_rt[each.value].id
}

# AWS Security group
resource "aws_security_group" "amui_sg_0" {
  name   = "amui_${var.vpc_name}_${var.customer_short}_sg_0"
  vpc_id = aws_vpc.amui_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.general_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.general_cidr_block]
  }
  tags = {
    Description = "Allow all Internet connections"
  }
}
