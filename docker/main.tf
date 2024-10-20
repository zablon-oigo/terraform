provider "aws" {
  region     = var.region
  secret_key = var.secret_key
  access_key = var.access_key
  token      = var.token
}
data "aws_vpc" "vpc" {
  default = true
}
resource "aws_security_group" "ec2_sg" {
  name        = "EBSDemo-SG"
  description = "Security group to allow traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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
resource "aws_instance" "ebsdemo" {
  ami           = "ami-08c47e4b2806964ce"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = <<-EOF
      #!/bin/bash
        apt update -y
        apt upgrade -y
        apt install nginx docker.io -y
        systemctl enable nginx
        systemctl start nginx
        systemctl enable docker
        systemctl start docker
        docker pull zablondev/webserver:latest
        docker run --name web --rm -d -p 80:80 zablondev/webserver
  EOF
  tags = {
    name = "WebServer"
  }
}