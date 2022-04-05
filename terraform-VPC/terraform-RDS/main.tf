provider "aws" { profile = "default" }

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.27"
  instance_class       = "db.t2.micro"
  name                 = "mysqldb"
  username             = "deepali"
  password             = "myPassword"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = false
}
