resource "aws_db_subnet_group" "database" {
  name = "my-test-database-subnet-group"
  subnet_ids = var.persistance_subnets
}

resource "aws_db_instance" "primary_db" {
  allocated_storage    = 5
  identifier           = "primary"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "user"
  password             = "password8char"
  db_subnet_group_name = "${aws_db_subnet_group.database.id}"
/* availability_zone=  */
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  skip_final_snapshot    = true

#Backups are required in order to create a replica
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1
}
resource "aws_db_instance" "read_replica" {
  count = length(var.persistance_subnets)
  identifier             = "replic-${count.index}"
  replicate_source_db    = "primary"
  instance_class         = "db.t3.micro"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  allocated_storage      = 5
  skip_final_snapshot    = true
# disable backups to create DB faster
  backup_retention_period = 0
}


