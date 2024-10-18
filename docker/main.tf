provider "aws" {
    region = "${var.region}"
    secret_key = "${var.secret_key}"
    access_key = "${var.access_key}"
    token="${var.token}"
}
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key" {
  key_name   = "test"
  public_key = tls_private_key.key.public_key_openssh
}