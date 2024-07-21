 
provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}
# Creating DB Subnet Group
resource "aws_db_subnet_group" "mydb_subnet_group" {
  name       = "mydb-subnet-group"
  subnet_ids = [
                data.aws_subnet.subnet1.id,
                data.aws_subnet.subnet2.id
                ]
  tags = {
    Name = "MyDBSubnetGroup"
  }
}
  resource "aws_rds_cluster" "aurorards" {
    cluster_identifier      = "myauroracluster"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.12.0"
    database_name           = "MyDB"
    master_username         = "Admin"
    master_password         = "Test123"
    vpc_security_group_ids = [aws_security_group.allow_aurora.id]
    db_subnet_group_name  = aws_db_subnet_group.mydb_subnet_group.name
    storage_encrypted = false
    skip_final_snapshot   = true       
}