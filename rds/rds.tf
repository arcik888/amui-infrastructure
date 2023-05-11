
resource "aws_db_subnet_group" "amui_db_subnet_1" {
  name = "amui_${var.vpc_short}_${var.customer_short}_db_subnet_1"
  subnet_ids = [
    var.amui_private_subnet_1,
    var.amui_private_subnet_2
  ]
}

resource "aws_db_instance" "amui_auth_db" {
  engine                  = "postgres"
  engine_version          = "14.5"
  allocated_storage       = 20
  backup_retention_period = 7
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.amui_db_subnet_1.id
  identifier              = "amuiauthdb${var.customer_short}${var.vpc_short}"
  instance_class          = "db.t3.micro"
  db_name                 = "amui_auth_${var.customer_short}${var.vpc_short}"
  username                = "postgres"
  password                = var.db_password
  port                    = 5432
  publicly_accessible     = false
  storage_encrypted       = true
  storage_type            = "gp2"
  vpc_security_group_ids  = [var.amui_db_sg_1]
  skip_final_snapshot     = true
  tags = {
    Name        = "AMUI SQL AUTH Database ${var.customer_short}-${var.vpc_short}"
    Description = "Database of users authorization"
  }
}
