## How to Create a MySQL RDS Instance using Terraform
### Architecture Diagram
### Create a variable file
- Create a file and name the file **variables.tf** and press Enter to save it
- Paste the contents below into **variables.tf** file
```
variable "access_key" {
    description = "Access key to AWS console"
}
variable "secret_key" {
    description = "Secret key to AWS console"
}
variable "region" {
    description = "AWS region"
}
```
- In the above content, you are declaring a variable called, access_key, secret_key, and region with a short description of all 3.
- After pasting the above contents, save the file by pressing ctrl + S.
- Create another file and name the file **terraform.tfvars** and press Enter to save it.
- Paste the following into the **terraform.tfvars** file.
```
    region = "us-east-1"
    access_key = "<YOUR_ACCESS_KEY>"        
    secret_key = "<YOUR_SECRET_KEY>"
```
- In the above code, you are defining the dynamic values of variables declared earlier
- Replace the values of access_key and secret_key
- After replacing the values of access_key and secret_key, save the file by pressing Ctrl + S.
### Create a Security group for RDS Instance in main.tf file
- Create a new file and name the file **main.tf**
- paste the following code to **main.tf** file
```
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
```
- Next, we want to tell Terraform to create a default VPC, two subnets and a security group for RDS Database Instance
- To create a security group Paste the below content into the main.tf file after the provider
```
# Default VPC and Subnets 

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet" "subnet1" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1a"
}

data "aws_subnet" "subnet2" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1b"
}
 
# Creating a security group
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS instance"
  vpc_id      = data.aws_vpc.default.id
 
  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
### Create a RDS Database Instance in main.tf file
- To create a Database Subnet group and RDS Database Instance add another block of code just below the security group code into the main.tf file
```
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

# Creating RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = "mydatabaseinstance"
  allocated_storage    = 20
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "mydatabaseuser"
  password             = "mydatabasepassword"
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.mydb_subnet_group.name
  skip_final_snapshot  = true
  publicly_accessible  = true
}
```
### Create an Output file
- Create a new file and name the file **output.tf**
- paste the following into **output.tf** file
```
output "security_group_id" {
  value       = aws_security_group.rds_sg.id            
}
output "db_instance_endpoint" {
  value       = aws_db_instance.myinstance.endpoint         
}
```
### Apply terraform configurations
- Initialize Terraform by running the below command,
```
terraform init
```
- To generate the action plans run
```
terraform plan
```
- To create all the resources declared in main.tf configuration file run
```
terraform apply
```
