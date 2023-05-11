# data "aws_ami" "amzn_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
#   }
# }

data "aws_ami" "debian_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
}

data "aws_ec2_instance_type" "t2_micro" {
  instance_type = "t2.micro"
}

resource "aws_instance" "linux" {
  ami                    = data.aws_ami.debian_linux.id
  instance_type          = data.aws_ec2_instance_type.t2_micro.instance_type
  subnet_id              = var.amui_subnet_id
  key_name               = var.amui_instance_key
  vpc_security_group_ids = var.vpc_security_group_ids

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "Bastion Host ${var.vpc_short}- ${var.customer_short}"
  }

}
