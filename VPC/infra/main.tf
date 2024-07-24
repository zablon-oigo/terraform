provider "aws" {
  region     = "${var.region}"        
  access_key = "${var.access_key}"   
  secret_key = "${var.secret_key}"
}

# Defining VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"            # CIDR block for the VPC
  tags = {
    Name = "MyVPC"                      
  }
}

# Defining public subnet within the VPC
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.main.id}"    
  cidr_block              = "10.0.1.0/24"           # CIDR block for the subnet
  map_public_ip_on_launch = "true"                  # Enable auto-assign public IP
  availability_zone       = "us-east-1a"            
  tags = {
    Name = "PublicSubnet"                          
  }
}

# Defining private subnet within the VPC
resource "aws_subnet" "private-subnet" {
  vpc_id            = "${aws_vpc.main.id}"          
  cidr_block        = "10.0.2.0/24"                 # CIDR block for the subnet
  availability_zone = "us-east-1b"                 
  tags = {
    Name = "PrivateSubnet"                         
  }
}

# Defining an internet gateway for the VPC
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = "${aws_vpc.main.id}"                    
  tags = {
    Name = "MyInternetGateway"                      
  }
}

# Defining public route table and associating it with the public subnet
resource "aws_route_table" "publicrt" {
  vpc_id = "${aws_vpc.main.id}"                     
  route {
    cidr_block = "0.0.0.0/0"                        
    gateway_id = "${aws_internet_gateway.MyIGW.id}"  
  }
  tags = {
    Name = "PublicRouteTable"                      
  }
}

# Defining private route table 
resource "aws_route_table" "privatert" {
  vpc_id = "${aws_vpc.main.id}"                     
  tags = {
    Name = "PrivateRouteTable"                      
  }
}

# Associating public subnet with the public route table
resource "aws_route_table_association" "public-association" {
  subnet_id      = "${aws_subnet.public-subnet.id}"  
  route_table_id = "${aws_route_table.publicrt.id}"  
}

# Associating private subnet with the private route table
resource "aws_route_table_association" "private-association" {
  subnet_id      = "${aws_subnet.private-subnet.id}" 
  route_table_id = "${aws_route_table.privatert.id}" 
  
}
