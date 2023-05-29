terraform {

  cloud {
    organization = "arcik888-org"
    workspaces {
      name = "AWS_configuration"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.60.0"
    }
  }
}

provider "aws" {
  region = var.awsRegion
}

module "amui_vpc" {
  source             = "./network"
  vpc_name           = var.vpcName
  general_cidr_block = var.general_cidr_block
  customer_short     = var.customerShortName
}

resource "aws_key_pair" "amui_instance_key" {
  key_name   = "instance_key-${var.customerShortName}-${var.vpcShortName}"
  public_key = var.instance_key # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYAbb46rk4Y6pYF1vudQTnzMfSaCWgPZdKaN+8DmF4N artur@devenv"
}

resource "aws_security_group" "bastion_ssh" {
  name   = "bastion_ssh"
  vpc_id = module.amui_vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.general_cidr_block}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.general_cidr_block}"]
  }
  tags = {
    Description = "Allow connection to port 22 (SSH) connection from all internet"
  }
}

resource "aws_security_group" "internal_ssh_allow" {
  name   = "internal_ssh_allowed"
  vpc_id = module.amui_vpc.vpc_id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.bastion_ssh.id}",
    ]
    cidr_blocks = [
      "${module.amui_vpc.amui_private_subnet_cidr[0]}",
      "${module.amui_vpc.amui_private_subnet_cidr[1]}",
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.general_cidr_block}"]
  }

  tags = {
    Description = "Allow internal traffic to port 22 (SSH) connection"
  }
}

resource "aws_security_group" "amui_db_sg_1" {
  name   = "amui_db_sg_1"
  vpc_id = module.amui_vpc.vpc_id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_ssh.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Description = "Allow connection to port 5432 to PostgreSQL database"
  }
}

module "amui_instance_bastion" {
  source             = "./instances/bastion_host"
  amui_instance_name = "Bastion Host"
  amui_subnet_id     = module.amui_vpc.public_subnet_ids[0]
  amui_instance_key  = aws_key_pair.amui_instance_key.id
  customer_short     = var.customerShortName
  vpc_short          = var.vpcShortName
  vpc_security_group_ids = [
    "${aws_security_group.bastion_ssh.id}",
    "${aws_security_group.internal_ssh_allow.id}"
  ]
}

module "amui_instance_sql_master" {
  source                 = "./instances/linux"
  amui_subnet_id         = module.amui_vpc.private_subnet_ids[0]
  amui_instance_key      = aws_key_pair.amui_instance_key.id
  ebs_size               = var.sqlEbsSize
  vpc_security_group_ids = [aws_security_group.internal_ssh_allow.id]
  amui_instance_name     = var.amui_instance_name[0]
  customer_short         = var.customerShortName
  vpc_short              = var.vpcShortName
}

module "amui_instance_sql_replica" {
  count                  = var.amui_sql_replicas_number
  source                 = "./instances/linux"
  amui_subnet_id         = module.amui_vpc.private_subnet_ids[1]
  amui_instance_key      = aws_key_pair.amui_instance_key.id
  ebs_size               = var.sqlEbsSize
  vpc_security_group_ids = [aws_security_group.internal_ssh_allow.id]
  amui_instance_name     = "${var.amui_instance_name[1]}_${count.index + 1}"
  customer_short         = var.customerShortName
  vpc_short              = var.vpcShortName
}

module "infratools" {
  source                 = "./instances/infratools"
  amui_subnet_id         = module.amui_vpc.private_subnet_ids[0]
  amui_instance_key      = aws_key_pair.amui_instance_key.id
  ebs_size               = var.sqlEbsSize
  vpc_security_group_ids = [aws_security_group.internal_ssh_allow.id]
  customer_short         = var.customerShortName
  vpc_short              = var.vpcShortName
}

module "amui_rds" {
  source                = "./rds"
  amui_private_subnet_1 = module.amui_vpc.private_subnet_ids[0]
  amui_private_subnet_2 = module.amui_vpc.private_subnet_ids[1]
  amui_db_sg_1          = aws_security_group.amui_db_sg_1.id
  customer_short        = var.customerShortName
  vpc_short             = var.vpcShortName
  db_password           = var.db_password
}