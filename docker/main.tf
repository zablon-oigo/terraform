provider "aws" {
  region     = var.region
  secret_key = var.secret_key
  access_key = var.access_key
  token      = var.token
}
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key" {
  key_name   = "test"
  public_key = tls_private_key.key.public_key_openssh
}
data "aws_vpc" "vpc" {
  default = true
}
resource "aws_security_group" "ec2_sg" {
  name        = "EBSDemo-SG"
  description = "Security group to allow traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  key_name      = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = <<-EOF
     #!/bin/bash
      apt update -y
      apt upgrade -y
      apt install nginx -y
      systemctl enable nginx
      systemctl start nginx
      echo '<h1 style="color:red">Response coming from the server</h1>' > /var/www/html/index.html
EOF
  tags = {
    name = "WebServer"
  }
}
resource "local_sensitive_file" "private_key_file" {
  content = tls_private_key.key.private_key_pem
  filename            = "${path.module}/test.pem"
}