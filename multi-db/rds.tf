resource "aws_db_instance" "postgres" {
  identifier           = "multi-db-postgres"
  allocated_storage    = 20
  db_name              = var.db_name
  engine               = "postgres"
  engine_version       = "12" 
  instance_class       = "db.${var.instance_type}"
  username             = var.db_username
  password             = random_password.db_password.result
  port                 = var.db_port
  parameter_group_name = "default.postgres12"
  skip_final_snapshot  = true
  publicly_accessible  = false # Best practice
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "multi-db-postgres-instance"
  }
}
