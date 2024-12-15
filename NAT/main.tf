provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}			
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
   tags = {
    Name = "MyPublicSubnet"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
   tags = {
    Name = "MyPrivateSubnet"
  }
}			
