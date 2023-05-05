
resource "aws_db_subnet_group" "amui_db_subnet_1" {
  name = "amui-dev-db-subnet-1"
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
  identifier              = "amuiauthdb"
  instance_class          = "db.t3.micro"
  db_name                 = "amui_auth"
  username                = "postgres"
  password                = "Pa$$w0rd"
  port                    = 5432
  publicly_accessible     = true
  storage_encrypted       = true
  storage_type            = "gp2"
  vpc_security_group_ids  = [var.amui_db_sg_1]
  skip_final_snapshot     = true
  tags = {
    Name        = "SQL AUTH Database"
    Description = "Database of users authorization"
  }
}
