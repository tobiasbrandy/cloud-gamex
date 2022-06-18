resource "aws_db_instance" "uddin-sameed" {
  identifier             = "uddin-sameed"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  skip_final_snapshot    = true
  publicly_accessible    = true
  username               = "sameed"
  password               = "random_string.uddin-db-password.result}"
#Backups are required in order to create a replica
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1
}
resource "aws_db_instance" "uddin-sameed-read" {
  identifier             = "uddin-sameed-read"
  replicate_source_db    = aws_db_instance.uddin-sameed.identifier ## refer to the master instance
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  skip_final_snapshot    = true
  publicly_accessible    = true
# disable backups to create DB faster
  backup_retention_period = 0
}

