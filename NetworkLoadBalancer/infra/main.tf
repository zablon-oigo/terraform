provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}			
# Default VPC 
data "aws_vpc" "vpc" {
    default = true
}

data "aws_subnet" "subnet1" {
    vpc_id = data.aws_vpc.vpc.id
    availability_zone = "us-east-1a"
}

data "aws_subnet" "subnet2" {
    vpc_id = data.aws_vpc.vpc.id
    availability_zone = "us-east-1b"
}