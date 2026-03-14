resource "aws_db_instance" "mysql" {

  identifier = "greenfield-mysql-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = module.vpc.aws_db_subnet_group.db_subnet_group.name

  vpc_security_group_ids = [
    module.security.aws_security_group.rds_sg.id
  ]

  multi_az = false

  publicly_accessible = false

  storage_encrypted = true

  backup_retention_period = 7

  skip_final_snapshot = true

  tags = {
    Name = "greenfield-rds"
  }
}