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
resource "aws_security_group" "sg" {
  name="test-sg"
  vpc_id = data.aws_vpc.default.id
  ingress {
    to_port=443
    from_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc_endpoint" "vpcendpoint" {
  vpc_id             = data.aws_vpc.vpc.id
  subnet_ids         = [data.aws_subnet.subnet1.id]
  service_name       = "com.amazonaws.us-east-1.execute-api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.whiz_sg.id,]
  ip_address_type    = "ipv4"
}