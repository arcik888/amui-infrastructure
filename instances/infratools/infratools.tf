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

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.yaml")
}

resource "aws_instance" "infratools" {
  ami                    = data.aws_ami.debian_linux.id
  instance_type          = data.aws_ec2_instance_type.t2_micro.instance_type
  subnet_id              = var.amui_subnet_id
  key_name               = var.amui_instance_key
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = data.template_file.user_data.rendered

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = var.ebs_size
    volume_type = "gp2"
  }

  tags = {
    Name = "InfraTools ${var.vpc_short} - ${var.customer_short}"
  }

}
