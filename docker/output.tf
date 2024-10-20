output "private_key_pem" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}
output "instance_pulic_ip" {
  value = aws_instance.ebsdemo.public_ip  
}