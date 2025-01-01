provider "aws"{
    region=var.region
    access_key = var.access_key
    secret_key = var.secret_key
}
data "aws_vpc" "default"{
    default = true
}
data "aws_subnet" "subnet" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1a"
  
}